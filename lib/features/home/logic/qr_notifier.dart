import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/qr_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'qr_state.dart';

class QRNotifier extends StateNotifier<QRState> {
  final DioClient dioClient;

  QRNotifier(this.dioClient) : super(QRState());

  /// Helper method to handle common error scenarios
  void _handleError(DioException e, String operation) {
    final statusCode = e.response?.statusCode;
    String errorMessage;

    switch (statusCode) {
      case 400:
        errorMessage = 'QR Code ບໍ່ຖືກຕ້ອງ ຫຼື ບໍ່ສາມາດອ່ານໄດ້';
        break;
      case 401:
        errorMessage = 'ການຢືນຢັນລົ້ມເຫລວ. ກະລຸນາເຂົ້າສູ່ລະບົບໃໝ່';
        break;
      case 404:
        errorMessage = 'ບໍ່ພົບຂໍ້ມູນ QR Code';
        break;
      case 500:
        errorMessage = 'ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງ';
        break;
      default:
        errorMessage = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}';
    }

    state = state.copyWith(isLoading: false, errorMessage: errorMessage);
  }

  /// Helper method to handle general exceptions
  void _handleGeneralError(dynamic e) {
    state = state.copyWith(isLoading: false, errorMessage: 'ເກີດຂໍ້ຜິດພາດ: $e');
  }

  /// Validate QR code format
  bool _isValidQRCode(String qrCode) {
    if (qrCode.isEmpty) return false;

    // Basic validation - QR code should not be too short or too long
    if (qrCode.length < 10 || qrCode.length > 1000) return false;

    // Check if it contains basic QR code patterns
    return qrCode.contains('000201') || // EMV QR format
        qrCode.contains('https://') || // URL format
        qrCode.contains('tel:') || // Phone format
        qrCode.contains('mailto:'); // Email format
  }

  Future<void> generateQR(String accountNumber) async {
    if (accountNumber.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເລກບັນຊີບໍ່ຖືກຕ້ອງ',
      );
      return;
    }

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
          errorMessage:
              'ເກີດຂໍ້ຜິດພາດໃນການສ້າງ QR Code (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'generateQR');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  Future<void> decodeQR(String qr) async {
    if (!_isValidQRCode(qr)) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'QR Code ບໍ່ຖືກຕ້ອງ ຫຼື ບໍ່ສາມາດອ່ານໄດ້',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await dioClient.clientV2.post(
        'decode_qr_nbb_static',
        data: {'qr': qr},
      );

      if (response.statusCode == 201) {
        final decodedData = response.data['data'] as Map<String, dynamic>?;

        if (decodedData != null && decodedData.isNotEmpty) {
          // Validate that the decoded data contains account information
          final hasAccountInfo = _validateAccountInfo(decodedData);
          if (hasAccountInfo) {
            state = state.copyWith(
              isLoading: false,
              decodedQRData: decodedData,
            );
          } else {
            state = state.copyWith(
              isLoading: false,
              errorMessage: 'QR Code ບໍ່ມີຂໍ້ມູນເລກບັນຊີທີ່ຖືກຕ້ອງ',
            );
          }
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'ບໍ່ສາມາດຖອດລະຫັດ QR Code - ຂໍ້ມູນວ່າງ',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'ບໍ່ສາມາດຖອດລະຫັດ QR Code (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      _handleError(e, 'decodeQR');
    } catch (e) {
      _handleGeneralError(e);
    }
  }

  /// Validate that decoded data contains account information
  bool _validateAccountInfo(Map<String, dynamic> data) {
    // Check for common account number fields
    final accountFields = [
      '34',
      'accountNumber',
      'acno',
      'account',
      'acc',
      'number',
      'account_number',
      'account_no',
      'ac_no',
    ];

    for (final field in accountFields) {
      if (data.containsKey(field)) {
        final value = data[field];
        if (value != null && value.toString().isNotEmpty) {
          // Check if it's a nested object (like '34')
          if (value is Map<String, dynamic>) {
            if (value.containsKey('03') && value['03'] != null) {
              return true;
            }
          } else {
            // Check if it's a direct value
            final cleanValue = value.toString().replaceAll(
              RegExp(r'[^\d]'),
              '',
            );
            if (cleanValue.length >= 8 && cleanValue.length <= 20) {
              return true;
            }
          }
        }
      }
    }

    // Recursively search in nested objects
    return _searchForAccountInfo(data);
  }

  /// Recursively search for account information in nested data
  bool _searchForAccountInfo(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final entry in data.entries) {
        final key = entry.key.toLowerCase();
        final value = entry.value;

        if (key.contains('account') ||
            key.contains('acno') ||
            key.contains('number')) {
          if (value != null && value.toString().isNotEmpty) {
            final cleanValue = value.toString().replaceAll(
              RegExp(r'[^\d]'),
              '',
            );
            if (cleanValue.length >= 8 && cleanValue.length <= 20) {
              return true;
            }
          }
        }

        // Recursively search in nested objects
        if (value is Map<String, dynamic> || value is List) {
          if (_searchForAccountInfo(value)) {
            return true;
          }
        }
      }
    } else if (data is List) {
      for (final item in data) {
        if (_searchForAccountInfo(item)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Retry QR generation with the same account number
  Future<void> retryGenerateQR() async {
    final accountNumber = state.accountNumber;
    if (accountNumber != null && accountNumber.isNotEmpty) {
      await generateQR(accountNumber);
    }
  }

  /// Retry QR decoding with the last scanned QR code
  Future<void> retryDecodeQR(String qrCode) async {
    if (qrCode.isNotEmpty) {
      await decodeQR(qrCode);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = QRState();
  }
}
