import 'package:moblie_banking/core/models/qr_model.dart';

class QRState {
  final bool isLoading;
  final String? errorMessage;
  final QRResponse? qrResponse;
  final String? accountNumber;
  final Map<String, dynamic>? decodedQRData;

  QRState({
    this.isLoading = false,
    this.errorMessage,
    this.qrResponse,
    this.accountNumber,
    this.decodedQRData,
  });

  QRState copyWith({
    bool? isLoading,
    String? errorMessage,
    QRResponse? qrResponse,
    String? accountNumber,
    Map<String, dynamic>? decodedQRData,
  }) {
    return QRState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      qrResponse: qrResponse ?? this.qrResponse,
      accountNumber: accountNumber ?? this.accountNumber,
      decodedQRData: decodedQRData ?? this.decodedQRData,
    );
  }
}
