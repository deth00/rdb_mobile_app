import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_notifier.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_state.dart';

final selectPrimaryAccountNotifierProvider =
    StateNotifierProvider<
      SelectPrimaryAccountNotifier,
      SelectPrimaryAccountState
    >((ref) {
      return SelectPrimaryAccountNotifier();
    });

final selectPrimaryAccountStateProvider = Provider<SelectPrimaryAccountState>((
  ref,
) {
  return ref.watch(selectPrimaryAccountNotifierProvider);
});

final selectPrimaryAccountAccountsProvider = Provider<List<DepositAccount>>((
  ref,
) {
  return ref.watch(selectPrimaryAccountNotifierProvider).accounts;
});

final selectPrimaryAccountSelectedProvider = Provider<DepositAccount?>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).selectedAccount;
});

final selectPrimaryAccountIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).isLoading;
});

final selectPrimaryAccountIsUpdatingProvider = Provider<bool>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).isUpdating;
});

final selectPrimaryAccountErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).errorMessage;
});
