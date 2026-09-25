class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String doctorImage;
  final DateTime date;
  final String time;
  final String status;
  final String reason;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.doctorImage,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
  });

  factory AppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final doctor = json['doctor'];

    return AppointmentModel(
      id: json['_id']?.toString() ?? '',
      doctorId: doctor is Map
          ? doctor['_id']?.toString() ?? ''
          : '',
      doctorName: doctor is Map
          ? doctor['name']?.toString() ?? ''
          : '',
      specialization: doctor is Map
          ? doctor['specialization']?.toString() ?? ''
          : '',
      doctorImage: doctor is Map
          ? doctor['image']?.toString() ?? ''
          : '',
      date: DateTime.parse(
        json['date'].toString(),
      ),
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}
