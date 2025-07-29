import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/account_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'fund_account_state.dart';

class FundAccountNotifier extends StateNotifier<FundAccountState> {
  final DioClient dioClient;

  FundAccountNotifier(this.dioClient) : super(FundAccountState());

  Future<void> getFundAccountDetail(String acno) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.client.get(
        'v1/act/get_fund_account_core/',
        queryParameters: {'acno': acno},
      );

      if (response.statusCode == 200) {
        final fundAccountResponse = FundAccountResponse.fromJson(response.data);

        if (fundAccountResponse.isHave && fundAccountResponse.data.isNotEmpty) {
          final fundAccountDetail = fundAccountResponse.data.first;
          state = state.copyWith(
            isLoading: false,
            fundAccountDetail: fundAccountDetail,
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

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = FundAccountState();
  }
}
