class DoctorAppointmentModel {
  final String id;

  final String patientId;
  final String patientName;
  final String patientEmail;
  final String patientPhone;

  final String doctorId;

  final DateTime date;
  final String time;
  final String status;
  final String reason;

  DoctorAppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
  });

  factory DoctorAppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final patient = json['patient'];

    final doctor = json['doctor'];

    return DoctorAppointmentModel(
      id: json['_id']?.toString() ?? '',

      patientId: patient is Map
          ? patient['_id']?.toString() ?? ''
          : '',

      patientName: patient is Map
          ? patient['name']?.toString() ?? ''
          : '',

      patientEmail: patient is Map
          ? patient['email']?.toString() ?? ''
          : '',

      patientPhone: patient is Map
          ? patient['phone']?.toString() ?? ''
          : '',

      doctorId: doctor is Map
          ? doctor['_id']?.toString() ?? ''
          : doctor?.toString() ?? '',

      date: DateTime.parse(
        json['date'].toString(),
      ),

      time: json['time']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      reason: json['reason']?.toString() ?? '',
    );
  }
}