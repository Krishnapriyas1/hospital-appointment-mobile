import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';
import 'package:hospital_appointment_mobile/core/network/api_client.dart';

import '../models/doctor_appointment_model.dart';

class DoctorAppointmentRepository {
  final ApiClient apiClient;

  DoctorAppointmentRepository({
    required this.apiClient,
  });

  // =========================================================
  // GET DOCTOR APPOINTMENTS
  // =========================================================

  Future<List<DoctorAppointmentModel>>
      getDoctorAppointments() async {
    final response = await apiClient.get(
      '${ApiConstants.appointments}/doctor/my',
    );

    final data =
        response.data as Map<String, dynamic>;

    final appointments =
        data['appointments'] as List<dynamic>? ?? [];

    return appointments
        .map(
          (item) =>
              DoctorAppointmentModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ============================
  // UPDATE APPOINTMENT STATUS
  // ============================

  Future<DoctorAppointmentModel>
      updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    final response = await apiClient.patch(
      '${ApiConstants.appointments}/$appointmentId/status',
      data: {
        'status': status,
      },
    );

    final data =
        response.data as Map<String, dynamic>;

    return DoctorAppointmentModel.fromJson(
      data['appointment']
          as Map<String, dynamic>,
    );
  }
}