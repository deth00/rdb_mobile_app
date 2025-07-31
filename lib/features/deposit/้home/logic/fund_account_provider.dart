import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'fund_account_notifier.dart';
import 'fund_account_state.dart';

final fundAccountNotifierProvider =
    StateNotifierProvider<FundAccountNotifier, FundAccountState>((ref) {
      final dio = ref.read(dioClientProvider);
      return FundAccountNotifier(dio);
    });
