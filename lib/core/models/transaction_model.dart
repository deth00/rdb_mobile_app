class Transaction {
  final String txcode;
  final String defacno;
  final String stdt;
  final String txrefid;
  final double amt;
  final String descs;
  final String valuedt;
  final String usrname;
  final String descr;

  Transaction({
    required this.txcode,
    required this.defacno,
    required this.stdt,
    required this.txrefid,
    required this.amt,
    required this.descs,
    required this.valuedt,
    required this.usrname,
    required this.descr,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      txcode: json['TXCODE'] ?? '',
      defacno: json['DEFACNO'] ?? '',
      stdt: json['STDT'] ?? '',
      txrefid: json['TXREFID'] ?? '',
      amt: (json['AMT'] ?? 0.0).toDouble(),
      descs: json['DESCS'] ?? '',
      valuedt: json['STDT'] ?? '', // Using STDT as valuedt for grouping
      usrname: json['USRNAME'] ?? '',
      descr: json['DESCR'] ?? '',
    );
  }
}
