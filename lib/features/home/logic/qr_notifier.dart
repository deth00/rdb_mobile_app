import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/qr_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'qr_state.dart';

class QRNotifier extends StateNotifier<QRState> {
  final DioClient dioClient;

  QRNotifier(this.dioClient) : super(QRState());

  Future<void> generateQR(String accountNumber) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      accountNumber: accountNumber,
    );

    try {
      final response = await dioClient.clientV2.post(
        'generate_qr_nbb_static',
        data: {'acno': accountNumber},
      );

      if (response.statusCode == 201) {
        final qrResponse = QRResponse.fromJson(response.data);
        state = state.copyWith(isLoading: false, qrResponse: qrResponse);
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

  Future<void> decodeQR(String qr) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await dioClient.clientV2.post(
        'decode_qr_nbb_static',
        data: {'qr': qr},
      );
      if (response.statusCode == 201) {
        final decodedData = response.data['data'] as Map<String, dynamic>?;
        state = state.copyWith(isLoading: false, decodedQRData: decodedData);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'ບໍ່ສາມາດຖອດລະຫັດ QR Code',
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
    state = QRState();
  }
}
