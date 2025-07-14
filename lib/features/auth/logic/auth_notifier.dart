import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/user_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final DioClient dioClient;
  final SecureStorage storage;

  AuthNotifier(this.dioClient, this.storage) : super(AuthState());

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await dioClient.client.post(
        'v1/login',
        data: {'phone': phone, 'password': password},
      );
      final code = response.statusCode ?? 0;
      if (code == 200) {
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];
        final user = User.fromJson(response.data['userData']);

        await storage.saveAccessToken(accessToken);
        await storage.saveRefreshToken(refreshToken);
        state = AuthState(isLoading: false, isLoggedIn: true, user: user);
      }
    } on DioError catch (e) {
      state = state.copyWith(isLoading: false);
      state = state.copyWith(errorMessage: '${e}');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Register error: $e');
    }
  }

  Future<void> cKPone(String phone) async {
    // state = state.copyWith(isLoading: true);
    try {
      final response = await dioClient.client.post(
        'v2/register',
        data: {"phone": phone},
      );
      final code = response.statusCode ?? 0;
      if (code == 200) {
        final otp = response.data['otp_id'];
        await storage.saveOtpId(otp);
        await storage.savePhone(phone);
        state = state.copyWith(successMessage: 'OTP sent successfully');
      }
    } on DioError catch (e) {
      print(e.toString());
      state = state.copyWith(errorMessage: 'error');
    } catch (e) {
      state = state.copyWith(errorMessage: 'server error');
    }
  }

  Future<void> register(String phone, String password) async {
    // state = state.copyWith(isLoading: true);
    try {
      final otpID = await storage.getOtpId();
      final otpcode = await storage.getOTP();
      final response = await dioClient.client.post(
        'v2/insert_user',
        data: {
          "otp_id": otpID,
          "otp": otpcode,
          "phone": phone,
          "password": password,
        },
      );
      final code = response.statusCode ?? 0;
      if (code == 200) {
        state = state.copyWith(successMessage: 'successfully');
      }
    } on DioError catch (e) {
      print(e.toString());
      state = state.copyWith(errorMessage: 'error');
    } catch (e) {
      print('Register error: $e');
    }
  }

  Future<void> forgotPassword(String phone) async {
    // state = state.copyWith(isLoading: true);
    try {
      final response = await dioClient.client.post(
        'v2/forgot_password',
        data: {"phone": phone},
      );
      final code = response.statusCode ?? 0;
      if (code == 200) {
        final otp = response.data['otp_id'];
        await storage.saveOtpId(otp);
        await storage.savePhone(phone);
        state = state.copyWith(successMessage: 'OTP sent successfully');
      }
    } on DioError catch (e) {
      print(e.toString());
      state = state.copyWith(errorMessage: 'error');
    } catch (e) {
      print('Register error: $e');
    }
  }

  Future<void> createPassword(String password, String passwordVerify) async {
    try {
      final otpID = await storage.getOtpId();
      final otpcode = await storage.getOTP();
      final phone = await storage.getPhone();
      final response = await dioClient.client.post(
        'v2/create_password',
        data: {
          "otp_id": otpID,
          "otp": otpcode,
          "phone": phone,
          "passwordNew": password,
          "passwordVerify": passwordVerify,
        },
      );
      print(response);
      final code = response.statusCode ?? 0;
      if (code == 201) {
        state = state.copyWith(successMessage: 'successfully');
      }
    } on DioError catch (e) {
      print(e.toString());
      state = state.copyWith(errorMessage: 'error');
    } catch (e) {
      print('Register error: $e');
    }
  }

  Future<void> refreshToken() async {
    try {
      final refresh = await storage.getRefreshToken();
      final response = await dioClient.client.post(
        'v1/refreshToken',
        data: {"refreshToken": refresh},
      );
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      await storage.saveAccessToken(accessToken);
      if (refreshToken != null) {
        await storage.saveRefreshToken(refreshToken); // เผื่อ backend ออกใหม่
      }
    } catch (e) {
      print('Register error: $e');
    }
  }

  Future<void> biometricLogin() async {
    try {
      await storage.loginWithBiometric();
      state = state.copyWith(successMessage: 'success');
    } catch (e) {
      state = state.copyWith(errorMessage: '${e}');
    }
  }

  Future<void> _load() async {
    final value = await storage.isBiometricEnabled();
    state = state.copyWith(successMessage: value.toString());
  }

  Future<void> toggle(bool value) async {
    await storage.setBiometricEnabled(value);
    state = state.copyWith(successMessage: value.toString());
  }

  Future<void> logout() async {
    await storage.clearAll();
    state = AuthState(); // กลับไปยังสถานะเริ่มต้น
  }

 
  void setLoginFromToken(User user) {
    state = AuthState(isLoading: false, isLoggedIn: true, user: user);
  }
}
