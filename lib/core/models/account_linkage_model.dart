class AccountLinkage {
  final int userLinkId;
  final String linkType;
  final int userId;
  final String linkValue;
  final String? linkDetail;
  final String passSts;
  final String createDate;

  AccountLinkage({
    required this.userLinkId,
    required this.linkType,
    required this.userId,
    required this.linkValue,
    this.linkDetail,
    required this.passSts,
    required this.createDate,
  });

  factory AccountLinkage.fromJson(Map<String, dynamic> json) {
    return AccountLinkage(
      userLinkId: json['user_link_id'] ?? 0,
      linkType: json['link_type'] ?? '',
      userId: json['user_id'] ?? 0,
      linkValue: json['link_value'] ?? '',
      linkDetail: json['link_detail'],
      passSts: json['pass_sts'] ?? '',
      createDate: json['create_date'] ?? '',
    );
  }
}
