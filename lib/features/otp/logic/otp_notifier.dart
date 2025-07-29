import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';
import 'package:moblie_banking/features/otp/logic/otp_state.dart';

class OtpNotifier extends StateNotifier<OtpState> {
  final DioClient dioClient;
  final SecureStorage storage;
  // Timer? _timer;
  Timer? _otpTimer;

  OtpNotifier(this.dioClient, this.storage) : super(OtpState());

  // void startCooldown([int seconds = 60]) {
  //   _timer?.cancel(); // เคลียร์ timer เก่า
  //   state = state.copyWith(resendSecondsLeft: seconds);

  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (state.resendSecondsLeft <= 1) {
  //       timer.cancel();
  //       state = state.copyWith(resendSecondsLeft: 0);
  //     } else {
  //       state = state.copyWith(resendSecondsLeft: state.resendSecondsLeft - 1);
  //     }
  //   });
  // }

  void startOtpExpireTimer([int seconds = 240]) {
    _otpTimer?.cancel();
    state = state.copyWith(otpExpiresIn: seconds);

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.otpExpiresIn <= 1) {
        timer.cancel();
        state = state.copyWith(otpExpiresIn: 0);
      } else {
        state = state.copyWith(otpExpiresIn: state.otpExpiresIn - 1);
      }
    });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _otpTimer?.cancel(); // ป้องกัน memory leak
    super.dispose();
  }

  Future<void> vertifyOTP(String code) async {
    state = state.copyWith(status: OtpStatus.verifying, errorMessage: null);

    try {
      final id = await storage.getOtpId();
      final response = await dioClient.clientV2.post(
        'verify_otp',
        data: {'otp_id': id, 'otp': code},
      );
      print(response);

      await storage.saveOtp(code);
      state = state.copyWith(status: OtpStatus.success);
    } on DioError catch (e) {
      final error = e.response?.data['message'] ?? 'ລະຫັດບໍ່ຖືກຕ້ອງ';
      state = state.copyWith(status: OtpStatus.error, errorMessage: error);
    } catch (e) {
      state = state.copyWith(
        status: OtpStatus.error,
        errorMessage: 'ເກິດຂໍ້ຜິດພາດ',
      );
    }
  }
}
