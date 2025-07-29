import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/account_linkage_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final DioClient dioClient;

  HomeNotifier(this.dioClient) : super(HomeState());

  Future<void> getAccountDPT() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.client.get(
        'v1/act/get_linkage',
        queryParameters: {'link_type': 'DPT'},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final accountList = data
            .map((json) => AccountLinkage.fromJson(json))
            .toList();

        state = state.copyWith(isLoading: false, accountDpt: accountList);
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

  Future<void> generateQR() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.clientV2.post(
        'generate_qr_nbb_static',
        data: {'acno': state.accountDpt.first.linkValue},
      );

      if (response.statusCode == 201) {
        final qrCode = response.data['qr'];
        state = state.copyWith(isLoading: false, qrCode: qrCode);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການສ້າງ QR Code',
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
}
