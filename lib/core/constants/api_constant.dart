class ApiConstants {
  static const String baseUrl = 'http://localhost:5001/api';

  // =========================
  // AUTH
  // =========================

  static const String patientRequestOtp =
      '/auth/patient/request-otp';

  static const String patientVerifyOtp =
      '/auth/patient/verify-otp';

  static const String doctorLogin =
      '/auth/doctor/login';

  static const String getMe =
      '/auth/me';

  // =========================
  // CATEGORIES
  // =========================

  static const String categories =
      '/categories';

  // =========================
  // DOCTORS
  // =========================

  static const String doctors =
      '/doctors';

  // =========================
  // APPOINTMENTS
  // =========================

  static const String appointments =
      '/appointments';

  static String cancelAppointment(String id) =>
      '/appointments/$id/cancel';

  // =========================
  // DOCTOR APPOINTMENTS
  // =========================

  static const String doctorAppointments =
      '/appointments/doctor/my';

  static String updateAppointmentStatus(String id) =>
      '/appointments/$id/status';

  // =========================
  // PRESCRIPTIONS
  // =========================

  static const String prescriptions =
      '/prescriptions';
}