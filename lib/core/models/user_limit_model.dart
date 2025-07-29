class UserLimit {
  final int tlId;
  final int userId;
  final double transferLimit;

  UserLimit({
    required this.tlId,
    required this.userId,
    required this.transferLimit,
  });

  factory UserLimit.fromJson(Map<String, dynamic> json) {
    return UserLimit(
      tlId: json['tl_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      transferLimit: (json['transfer_limit'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'tl_id': tlId, 'user_id': userId, 'transfer_limit': transferLimit};
  }
}
