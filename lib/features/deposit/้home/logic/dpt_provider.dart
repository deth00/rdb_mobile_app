import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_notifier.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_state.dart';

final dptNotifierProvider = StateNotifierProvider<DptNotifier, DptState>((ref) {
  final dio = ref.read(dioClientProvider);
  return DptNotifier(dio);
});
