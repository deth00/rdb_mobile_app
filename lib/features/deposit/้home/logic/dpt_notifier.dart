import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/account_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'dpt_state.dart';

class DptNotifier extends StateNotifier<DptState> {
  final DioClient dioClient;

  DptNotifier(this.dioClient) : super(DptState());

  Future<void> getAccountDetail(String acno) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // First, get account linkage info
      final linkageResponse = await dioClient.client.get(
        'v1/act/get_linkage',
        queryParameters: {'link_type': 'DPT'},
      );

      if (linkageResponse.statusCode == 200) {
        final data = linkageResponse.data['data'] as List;
        if (data.isNotEmpty) {
          // Find the account that matches the provided acno
          final accountData = data.firstWhere(
            (item) => item['link_value'] == acno,
            orElse: () => data.first, // Use first if not found
          );

          // Now get the balance from fund account API
          double balance = 0.0;
          try {
            final fundResponse = await dioClient.client.get(
              'v1/act/get_fund_account_core/',
              queryParameters: {'acno': acno},
            );
              
            if (fundResponse.statusCode == 200) {
              final fundAccountResponse = FundAccountResponse.fromJson(
                fundResponse.data,
              );
              if (fundAccountResponse.data.isNotEmpty) {
                balance = fundAccountResponse.data.first.balance;
              }
            }
          } catch (e) {
            // Balance API failed, continue with 0.0 balance
          }

          // Create account detail with balance
          final accountDetail = AccountDetail.fromJson({
            ...accountData,
            'balance': balance, // Add the balance from fund account API
          });

          state = state.copyWith(
            isLoading: false,
            accountDetail: accountDetail,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'ບໍ່ພົບຂໍ້ມູນບັນຊີ',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການເກັບຂໍ້ມູນ',
        );
      }
    } on DioError catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດ: $e',
      );
    }
  }

  Future<void> addAcno(String acno) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.client.post(
        'v1/act/insert_linkage',
        data: {'link_type': 'DPT', 'link_value': acno},
      );

      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການເພີ່ມບັນຊີ',
        );
      }
    } on DioError catch (e) {
      // Handle specific API error responses
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data['message'];
        if (errorMessage == 'already link') {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'ເລກບັນຊີນີ້ມີຢູ່ແລ້ວ',
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: errorMessage ?? 'ເລກບັນຊີບໍ່ຖືກຕ້ອງ',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດ: $e',
      );
    }
  }
}
