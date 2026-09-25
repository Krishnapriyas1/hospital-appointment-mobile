class ApiConstants {
  static const String baseUrl = 'http://localhost:5001/api';


  static const String patientRequestOtp =
      '/auth/patient/request-otp';

  static const String patientVerifyOtp =
      '/auth/patient/verify-otp';

  static const String doctorLogin =
      '/auth/doctor/login';

  static const String getMe =
      '/auth/me';

  static const String categories =
      '/categories';

  static const String doctors =
      '/doctors';

  static const String appointments =
      '/appointments';

  static String cancelAppointment(String id) =>
      '/appointments/$id/cancel';

  static const String doctorAppointments =
      '/appointments/doctor/my';

  static String updateAppointmentStatus(String id) =>
      '/appointments/$id/status';


  static const String prescriptions =
      '/prescriptions';
}