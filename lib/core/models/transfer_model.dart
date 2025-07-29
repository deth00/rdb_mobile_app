class ReceiverAccount {
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String bankName;
  final String accountType;

  ReceiverAccount({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.bankName,
    required this.accountType,
  });

  factory ReceiverAccount.fromJson(Map<String, dynamic> json) {
    return ReceiverAccount(
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountType: json['account_type'] ?? '',
    );
  }
}

class TransferRequest {
  final String fromAccount;
  final String toAccount;
  final double amount;
  final String description;
  final String transferType;

  TransferRequest({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.description,
    required this.transferType,
  });

  Map<String, dynamic> toJson() {
    return {
      'from_account': fromAccount,
      'to_account': toAccount,
      'amount': amount,
      'description': description,
      'transfer_type': transferType,
    };
  }
}

class TransferLimitUpdateRequest {
  final double amount;

  TransferLimitUpdateRequest({required this.amount});

  Map<String, dynamic> toJson() {
    return {'amount': amount};
  }
}

class TransferLimitResponse {
  final bool error;
  final String message;

  TransferLimitResponse({required this.error, required this.message});

  factory TransferLimitResponse.fromJson(Map<String, dynamic> json) {
    return TransferLimitResponse(
      error: json['error'] ?? true,
      message: json['message'] ?? '',
    );
  }
}
