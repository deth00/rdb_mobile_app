import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/otp/logic/otp_notifier.dart';
import 'package:moblie_banking/features/otp/logic/otp_state.dart';

final otpNotifierProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  final dio = ref.read(dioClientProvider);
  final storage = ref.read(secureStorageProvider);
  return OtpNotifier(dio, storage);
});
