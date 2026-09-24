class UserModel {
  final String id;
  final String name;
  final String? username;
  final String email;
  final String? phone;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    this.username,
    required this.email,
    this.phone,
    required this.role,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? '',
    );
  }
}