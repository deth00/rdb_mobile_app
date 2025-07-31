import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/transfer_model.dart';
import 'package:moblie_banking/core/models/account_model.dart';
import 'package:moblie_banking/core/models/user_limit_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'transfer_state.dart';

class TransferNotifier extends StateNotifier<TransferState> {
  final DioClient dioClient;

  // Constants
  static const String _defaultBankCode = 'NBB';
  static const String _defaultBankName = 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ';

  TransferNotifier(this.dioClient) : super(TransferState());

  /// Helper method to handle common error scenarios
  void _handleError(DioException e, String operation) {
    final statusCode = e.response?.statusCode;
    final errorMessage = statusCode == 500
        ? 'ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ (500). ກະລຸນາລອງໃໝ່ອີກຄັ້ງ.'
        : 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}';

    state = state.copyWith(isLoading: false, errorMessage: errorMessage);
  }

  /// Helper method to handle general exceptions
  void _handleGeneralError(dynamic e) {
    state = state.copyWith(isLoading: false, errorMessage: 'ເກີດຂໍ້ຜິດພາດ: $e');
  }

  Future<void> getUserLimit() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.client.get('v1/user_limit');
      print("ddddddddddddddddddddddddddddddddddd${123456}");
      if (response.statusCode == 200) {
        final userLimit = UserLimit.fromJson(response.data);
        state = state.copyWith(isLoading: false, userLimit: userLimit);
        print(state.userLimit);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'ບໍ່ສາມາດດຶງຂໍ້ມູນລິມິດໄດ້ (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'getUserLimit');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  Future<void> getAccountDetail(String accountNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // First, try to get account information from fund account API
      final response = await dioClient.client.get(
        'v1/act/get_fund_account_core/',
        queryParameters: {'acno': accountNumber},
      );
      if (response.statusCode == 200) {
        final fundAccountResponse = FundAccountResponse.fromJson(response.data);

        if (fundAccountResponse.isHave && fundAccountResponse.data.isNotEmpty) {
          final accountData = fundAccountResponse.data.first;

          // Create receiver account from fund account data
          final receiverAccount = ReceiverAccount(
            accountNumber: accountData.acNo,
            accountName: accountData.acName,
            bankCode: _defaultBankCode,
            bankName: _defaultBankName,
            accountType: accountData.catname,
          );
          state = state.copyWith(
            isLoading: false,
            receiverAccount: receiverAccount,
            status: true,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            receiverAccount: null,
            errorMessage: 'ບໍ່ພົບເລກບັນຊີນີ້',
            status: false,
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ບໍ່ພົບເລກບັນຊີນີ້ (Status: ${response.statusCode})',
          status: false,
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'getAccountDetail');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  /// Helper method to get account from linkage API
  Future<void> _getAccountFromLinkage(String accountNumber) async {
    try {
      final linkageResponse = await dioClient.client.get(
        'v1/act/get_linkage',
        queryParameters: {'link_type': 'DPT'},
      );

      if (linkageResponse.statusCode == 200) {
        final data = linkageResponse.data['data'] as List;
        final matchingAccount = data.cast<Map<String, dynamic>>().firstWhere(
          (item) => item['link_value'] == accountNumber,
          orElse: () => <String, dynamic>{},
        );

        if (matchingAccount.isNotEmpty) {
          final receiverAccount = ReceiverAccount(
            accountNumber: matchingAccount['link_value'],
            accountName: matchingAccount['link_name'] ?? 'Unknown',
            bankCode: _defaultBankCode,
            bankName: _defaultBankName,
            accountType: 'DPT',
          );

          state = state.copyWith(
            isLoading: false,
            receiverAccount: receiverAccount,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'ບໍ່ພົບເລກບັນຊີນີ້',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'ບໍ່ພົບເລກບັນຊີນີ້ (Status: ${linkageResponse.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'getAccountFromLinkage');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  Future<void> performTransfer(TransferRequest request) async {
    // Reset transfer success state before starting new transfer
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isTransferSuccess: false,
    );

    try {
      // Try using v2 API for transfer
      final response = await dioClient.clientV2.post(
        'transfer',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(isLoading: false, isTransferSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ການໂອນເງິນລົ້ມເຫລວ (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // If v2 fails, try v1 as fallback (but not for 500 errors)
      if (statusCode != 500) {
        await _performTransferFallback(request);
      } else {
        // 500 error from v2 API
        final errorMessage =
            'ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ (500). ກະລຸນາລອງໃໝ່ອີກຄັ້ງ.';

        state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      }
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  /// Helper method for fallback transfer using v1 API
  Future<void> _performTransferFallback(TransferRequest request) async {
    try {
      final fallbackResponse = await dioClient.client.post(
        'v1/transfer',
        data: request.toJson(),
      );

      if (fallbackResponse.statusCode == 200 ||
          fallbackResponse.statusCode == 201) {
        state = state.copyWith(isLoading: false, isTransferSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'ການໂອນເງິນລົ້ມເຫລວ (Status: ${fallbackResponse.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'performTransferFallback');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  Future<void> updateTransferLimit(double newAmount) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final request = TransferLimitUpdateRequest(amount: newAmount);
      final response = await dioClient.client.put(
        'v1/user_limit',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final limitResponse = TransferLimitResponse.fromJson(response.data);

        if (!limitResponse.error) {
          // Refresh user limit after successful update
          await getUserLimit();

          state = state.copyWith(
            isLoading: false,
            isLimitUpdateSuccess: true,
            successMessage: limitResponse.message,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: limitResponse.message,
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'ການອັບເດດລິມິດລົ້ມເຫລວ (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'updateTransferLimit');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSuccess() {
    state = state.copyWith(
      isLimitUpdateSuccess: false,
      successMessage: null,
      isTransferSuccess: false,
    );
  }

  void reset() {
    state = TransferState();
  }
}
