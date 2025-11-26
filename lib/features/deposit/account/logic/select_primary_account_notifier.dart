import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_state.dart';
import 'package:moblie_banking/core/services/api_service.dart';

class SelectPrimaryAccountNotifier
    extends StateNotifier<SelectPrimaryAccountState> {
  final DioClient _dioClient = DioClient();

  SelectPrimaryAccountNotifier() : super(const SelectPrimaryAccountState()) {
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Use the existing DioClient which already handles authentication
      final response = await _dioClient.client.get(
        'v1/act/get_linkage',
        queryParameters: {'link_type': 'DPT'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;

        if (jsonResponse['verify'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];

          // Fetch detailed account information for each account
          final List<DepositAccount> accounts = [];

          for (final accountData in data) {
            final accountNumber = accountData['link_value'] ?? '';
            if (accountNumber.isNotEmpty) {
              try {
                // Get detailed account information
                final accountResponse = await _dioClient.client.get(
                  'v1/act/get_fund_account_core/',
                  queryParameters: {'acno': accountNumber},
                );

                if (accountResponse.statusCode == 200) {
                  final accountDetails = accountResponse.data;
                  if (accountDetails['isHave'] == true &&
                      accountDetails['data'] != null &&
                      accountDetails['data'].isNotEmpty) {
                    final accountInfo = accountDetails['data'][0];

                    accounts.add(
                      DepositAccount(
                        accountType:
                            accountInfo['catname'] ?? 'ບັນຊີເງິນຝາກປະຢັດ (LAK)',
                        accountName: accountInfo['ACNAME'] ?? 'Unknown',
                        accountNumber: accountNumber,
                        balance: (accountInfo['Balance'] ?? 0.0).toDouble(),
                        isPrimary:
                            false, // Will be determined by business logic
                        currency: 'LAK',
                      ),
                    );
                  } else {
                    // Fallback if detailed info not available
                    accounts.add(
                      DepositAccount(
                        accountType: 'ບັນຊີເງິນຝາກປະຢັດ (LAK)',
                        accountName: 'Unknown',
                        accountNumber: accountNumber,
                        balance: 0.0,
                        isPrimary: false,
                        currency: 'LAK',
                      ),
                    );
                  }
                } else {
                  // Fallback if API call fails
                  accounts.add(
                    DepositAccount(
                      accountType: 'ບັນຊີເງິນຝາກປະຢັດ (LAK)',
                      accountName: 'Unknown',
                      accountNumber: accountNumber,
                      balance: 0.0,
                      isPrimary: false,
                      currency: 'LAK',
                    ),
                  );
                }
              } catch (e) {
                // Fallback if any error occurs
                accounts.add(
                  DepositAccount(
                    accountType: 'ບັນຊີເງິນຝາກປະຢັດ (LAK)',
                    accountName: 'Unknown',
                    accountNumber: accountNumber,
                    balance: 0.0,
                    isPrimary: false,
                    currency: 'LAK',
                  ),
                );
              }
            }
          }

          if (accounts.isNotEmpty) {
            // Set the first account as primary by default
            final updatedAccounts = accounts.map((account) {
              return account.copyWith(
                isPrimary: accounts.indexOf(account) == 0,
              );
            }).toList();

            final selectedAccount = updatedAccounts.firstWhere(
              (account) => account.isPrimary,
            );

            state = state.copyWith(
              accounts: updatedAccounts,
              selectedAccount: selectedAccount,
              isLoading: false,
              errorMessage: null,
            );
          } else {
            state = state.copyWith(
              accounts: [],
              selectedAccount: null,
              isLoading: false,
              errorMessage: 'ບໍ່ມີບັນຊີເງິນຝາກ',
            );
          }
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid response format or verification failed',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch accounts: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດຂໍ້ມູນ: $e',
      );
    }
  }

  void selectAccount(DepositAccount account) {
    // Update all accounts to set the selected one as primary
    final updatedAccounts = state.accounts.map((acc) {
      return acc.copyWith(
        isPrimary: acc.accountNumber == account.accountNumber,
      );
    }).toList();

    state = state.copyWith(accounts: updatedAccounts, selectedAccount: account);
  }

  Future<void> updatePrimaryAccount() async {
    if (state.selectedAccount == null) return;

    state = state.copyWith(isUpdating: true);

    try {
      // TODO: Implement API call to update primary account
      // This would be a PUT/POST request to update the primary account status

      // Example implementation:
      // final response = await _dioClient.client.put(
      //   'act/update_primary_account',
      //   data: {'account_number': state.selectedAccount!.accountNumber},
      // );

      // Simulate API delay for now
      await Future.delayed(const Duration(seconds: 1));

      // For now, return success
      state = state.copyWith(isUpdating: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການອັບເດດບັນຊີຫຼັກ: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> refreshAccounts() async {
    await _loadAccounts();
  }
}
