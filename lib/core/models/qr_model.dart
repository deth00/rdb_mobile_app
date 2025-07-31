class QRResponse {
  final String message;
  final String type;
  final String qr;

  QRResponse({required this.message, required this.type, required this.qr});

  factory QRResponse.fromJson(Map<String, dynamic> json) {
    return QRResponse(
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      qr: json['qr'] ?? '',
    );
  }
}
