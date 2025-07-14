class User {
  final int userId;
  final String phone;
  final String firstName;
  final String lastName;
  final String? profile;

  User({
    required this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      phone: json['user_phone'],
      firstName: json['user_name_en'],
      lastName: json['user_lastname_en'] ?? '',
      profile: json['user_profile'],
    );
  }
}
