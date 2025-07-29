import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_notifier.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_state.dart';

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
      final dio = ref.read(dioClientProvider);
      return TransactionNotifier(dio);
    });
