class DoctorAvailability {
  final DateTime date;
  final List<String> slots;

  DoctorAvailability({
    required this.date,
    required this.slots,
  });

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      date: DateTime.parse(json['date'].toString()),
      slots: (json['slots'] as List<dynamic>? ?? [])
          .map((slot) => slot.toString())
          .toList(),
    );
  }
}

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
  final List<DoctorAvailability> availability;

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
    this.availability = const [],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    final availabilityJson =
        json['availability'] as List<dynamic>? ?? [];

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
      availability: availabilityJson
          .map(
            (item) => DoctorAvailability.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}