import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/home/logic/home_notifier.dart';
import 'package:moblie_banking/features/home/logic/home_state.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final dio = ref.read(dioClientProvider);
  return HomeNotifier(dio);
});
