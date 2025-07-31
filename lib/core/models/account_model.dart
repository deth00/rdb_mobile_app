// Model for linked accounts (from get_linkage endpoint)
class AccountDetail {
  final String acNo;
  final double balance;
  final String accountType;
  final String status;
  final String? currency;

  AccountDetail({
    required this.acNo,
    required this.balance,
    required this.accountType,
    required this.status,
    this.currency,
  });

  factory AccountDetail.fromJson(Map<String, dynamic> json) {
    // Try different possible balance field names
    dynamic balanceValue =
        json['balance'] ??
        json['Balance'] ??
        json['BALANCE'] ??
        json['amount'] ??
        json['Amount'] ??
        json['AMOUNT'] ??
        0.0;

    return AccountDetail(
      acNo: json['link_value'] ?? '',
      balance: (balanceValue ?? 0.0).toDouble(),
      accountType: json['link_type'] ?? '',
      status: json['pass_sts'] ?? '',
      currency: json['currency'],
    );
  }
}

// Model for fund account core details (from get_fund_account_core endpoint)
class FundAccountDetail {
  final String acNo;
  final String acName;
  final double balance;
  final double intpbl;
  final String catname;
  final MobilePhone mphone;
  final int minAmt;

  FundAccountDetail({
    required this.acNo,
    required this.acName,
    required this.balance,
    required this.intpbl,
    required this.catname,
    required this.mphone,
    required this.minAmt,
  });

  factory FundAccountDetail.fromJson(Map<String, dynamic> json) {
    return FundAccountDetail(
      acNo: json['ACNO'] ?? '',
      acName: json['ACNAME'] ?? '',
      balance: (json['Balance'] ?? 0.0).toDouble(),
      intpbl: (json['Intpbl'] ?? 0.0).toDouble(),
      catname: json['catname'] ?? '',
      mphone: MobilePhone.fromJson(json['mphone'] ?? {}),
      minAmt: json['MINAMT'] ?? 0,
    );
  }
}

// Model for mobile phone details
class MobilePhone {
  final String hp;
  final String fp;
  final String cp;

  MobilePhone({required this.hp, required this.fp, required this.cp});

  factory MobilePhone.fromJson(Map<String, dynamic> json) {
    return MobilePhone(
      hp: json['HP'] ?? '',
      fp: json['FP'] ?? '',
      cp: json['CP'] ?? '',
    );
  }
}

// API Response wrapper for fund account core
class FundAccountResponse {
  final String message;
  final bool isHave;
  final bool isEmpty;
  final List<FundAccountDetail> data;

  FundAccountResponse({
    required this.message,
    required this.isHave,
    required this.isEmpty,
    required this.data,
  });

  factory FundAccountResponse.fromJson(Map<String, dynamic> json) {
    return FundAccountResponse(
      message: json['message'] ?? '',
      isHave: json['isHave'] ?? false,
      isEmpty: json['isEmpty'] ?? true,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => FundAccountDetail.fromJson(item))
              .toList() ??
          [],
    );
  }
}
