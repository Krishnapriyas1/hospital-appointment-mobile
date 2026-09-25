import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';
import 'package:hospital_appointment_mobile/core/network/api_client.dart';

import '../models/appointment_model.dart';

class AppointmentRepository {
  final ApiClient apiClient;

  AppointmentRepository({
    required this.apiClient,
  });

  // ============================================================
  // PATIENT - BOOK APPOINTMENT
  // ============================================================

  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required DateTime date,
    required String time,
    String reason = '',
  }) async {
    final response = await apiClient.post(
      ApiConstants.appointments,
      data: {
        'doctor': doctorId,
        'date': date.toIso8601String(),
        'time': time,
        'reason': reason.trim(),
      },
    );

    final data = response.data as Map<String, dynamic>;

    return AppointmentModel.fromJson(
      data['appointment'],
    );
  }

  // ============================================================
  // PATIENT - GET MY APPOINTMENTS
  // ============================================================

  Future<List<AppointmentModel>> getMyAppointments() async {
    final response = await apiClient.get(
      '${ApiConstants.appointments}/my',
    );

    final data = response.data as Map<String, dynamic>;

    final appointments =
        data['appointments'] as List<dynamic>? ?? [];

    return appointments
        .map(
          (item) => AppointmentModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ============================================================
  // PATIENT - CANCEL APPOINTMENT
  // ============================================================

  Future<void> cancelAppointment(
    String id,
  ) async {
    await apiClient.patch(
      ApiConstants.cancelAppointment(id),
    );
  }

  // ============================================================
  // DOCTOR - GET APPOINTMENTS
  // ============================================================

  Future<List<AppointmentModel>>
      getDoctorAppointments() async {
    final response = await apiClient.get(
      '${ApiConstants.appointments}/doctor/my',
    );

    final data = response.data as Map<String, dynamic>;

    final appointments =
        data['appointments'] as List<dynamic>? ?? [];

    return appointments
        .map(
          (item) => AppointmentModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}