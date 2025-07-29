import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_notifier.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_state.dart';

final transferNotifierProvider =
    StateNotifierProvider<TransferNotifier, TransferState>((ref) {
      final dio = ref.read(dioClientProvider);
      return TransferNotifier(dio);
    });
