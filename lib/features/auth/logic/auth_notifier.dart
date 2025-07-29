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
      // Get mobile user agent using device_info_plus
      final userAgent = await storage.getMobileUserAgent();

      final response = await dioClient.client.post(
        'v1/login',
        data: {'phone': phone, 'password': password, 'userAgent': userAgent},
      );
      final code = response.statusCode ?? 0;
      if (code == 200) {
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];
        final user = User.fromJson(response.data['userData']);

        await storage.saveAccessToken(accessToken);
        await storage.saveRefreshToken(refreshToken);
        // Save phone number for biometric authentication
        await storage.savePhone(phone);
        // Save userAgent for refresh token requests
        await storage.saveUserAgent(userAgent);

        state = AuthState(isLoading: false, isLoggedIn: true, user: user);
        print('refreshToken === ${await storage.getRefreshToken()}');
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
      final response = await dioClient.clientV2.post(
        'register',
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
      final response = await dioClient.clientV2.post(
        'insert_user',
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
      final response = await dioClient.clientV2.post(
        'forgot_password',
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
      final response = await dioClient.clientV2.post(
        'create_password',
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
      final isAuthenticated = await storage.loginWithBiometric();
      if (!isAuthenticated) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ການຢືນຢັນດ້ວຍ Biometric ລົ້ມເຫລວ',
        );
        return;
      }
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ບໍ່ພົບ refresh token ກະລຸນາ login ດ້ວຍລະຫັດກ່ອນ',
        );
        return;
      }
      final userAgent = await storage.getUserAgent();
      final response = await dioClient.client.post(
        'v1/refreshToken',
        data: {
          "userAgent": userAgent ?? "moblie_banking",
          "refreshToken": refreshToken,
        },
      );
      if (response.data['accessToken'] == null ||
          response.data['userData'] == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Backend did not return valid session',
        );
        return;
      }

      final accessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];
      final user = User.fromJson(response.data['userData'][0]);
      await storage.saveAccessToken(accessToken);
      await storage.saveRefreshToken(newRefreshToken);
      state = AuthState(isLoading: false, isLoggedIn: true, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Biometric login failed: $e',
      );
    }
  }

  Future<void> authenticateWithBiometric() async {
    try {
      await storage.authenticateWithBiometric();
      // Authentication successful, no need to update state for settings
    } catch (e) {
      // Re-throw the error so the calling code can handle it
      throw e;
    }
  }

  Future<void> load() async {
    try {
      final isBiometricEnabled = await storage.isBiometricEnabled();
      final canUseBiometric = await storage.canUseBiometric();
      state = state.copyWith(
        canUseBiometric: canUseBiometric,
        isBiometricEnabled: isBiometricEnabled,
      );
    } catch (e) {
      state = state.copyWith(canUseBiometric: false, isBiometricEnabled: false);
    }
  }

  Future<void> _load() async {
    final value = await storage.isBiometricEnabled();
    state = state.copyWith(successMessage: value.toString());
  }

  Future<void> toggle(bool value) async {
    await storage.setBiometricEnabled(value);
    state = state.copyWith(
      isBiometricEnabled: value,
      successMessage: value.toString(),
    );
  }

  Future<void> logout() async {
    // await storage.clearAll();
    state = AuthState(); // กลับไปยังสถานะเริ่มต้น
  }

  void setLoginFromToken(User user) {
    state = AuthState(isLoading: false, isLoggedIn: true, user: user);
  }
}
