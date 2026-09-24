class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final dynamic experience;
  final String image;
  final String username;
  final String email;
  final String phone;
  final String? categoryId;
  final String? categoryName;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.image,
    required this.username,
    required this.email,
    required this.phone,
    this.categoryId,
    this.categoryName,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    return DoctorModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialization:
          json['specialization']?.toString() ?? '',
      experience: json['experience'],
      image: json['image']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      categoryId: category is Map
          ? category['_id']?.toString()
          : category?.toString(),
      categoryName:
          category is Map ? category['name']?.toString() : null,
    );
  }
}