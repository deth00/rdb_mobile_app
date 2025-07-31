import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/home/logic/qr_notifier.dart';
import 'package:moblie_banking/features/home/logic/qr_state.dart';

final qrNotifierProvider = StateNotifierProvider<QRNotifier, QRState>((ref) {
  final dio = ref.read(dioClientProvider);
  return QRNotifier(dio);
});
