import 'package:get/get.dart';

import '../data/doctor_appointment_repository.dart';
import '../models/doctor_appointment_model.dart';

class DoctorAppointmentController extends GetxController {
  final DoctorAppointmentRepository repository;

  DoctorAppointmentController({
    required this.repository,
  });

  final isLoading = false.obs;

  final isUpdating = false.obs;

  final errorMessage = ''.obs;

  final appointments =
      <DoctorAppointmentModel>[].obs;

  // =========================================================
  // LOAD APPOINTMENTS
  // =========================================================

  Future<void> loadAppointments() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result =
          await repository.getDoctorAppointments();

      appointments.assignAll(result);
    } catch (error) {
      errorMessage.value =
          _getErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // UPDATE STATUS
  // =========================================================

  Future<bool> updateStatus({
    required String appointmentId,
    required String status,
  }) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;
    errorMessage.value = '';

    try {
      await repository.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );

      await loadAppointments();

      return true;
    } catch (error) {
      errorMessage.value =
          _getErrorMessage(error);

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // =========================================================
  // UPCOMING
  // =========================================================

  List<DoctorAppointmentModel>
      get upcomingAppointments {
    final now = DateTime.now();

    final result =
        appointments.where((appointment) {
      if (appointment.status == 'cancelled' ||
          appointment.status == 'completed') {
        return false;
      }

      return _appointmentDateTime(
        appointment,
      ).isAfter(now);
    }).toList();

    result.sort(
      (a, b) => _appointmentDateTime(a)
          .compareTo(
        _appointmentDateTime(b),
      ),
    );

    return result;
  }

  // =========================================================
  // TODAY
  // =========================================================

  List<DoctorAppointmentModel>
      get todayAppointments {
    final now = DateTime.now();

    return appointments.where((appointment) {
      final date = appointment.date;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          appointment.status != 'cancelled';
    }).toList();
  }

  // =========================================================
  // COMPLETED
  // =========================================================

  List<DoctorAppointmentModel>
      get completedAppointments {
    return appointments
        .where(
          (appointment) =>
              appointment.status == 'completed',
        )
        .toList();
  }

  // =========================================================
  // CANCELLED
  // =========================================================

  List<DoctorAppointmentModel>
      get cancelledAppointments {
    return appointments
        .where(
          (appointment) =>
              appointment.status == 'cancelled',
        )
        .toList();
  }

  // =========================================================
  // DATE + TIME
  // =========================================================

  DateTime _appointmentDateTime(
    DoctorAppointmentModel appointment,
  ) {
    final parts =
        appointment.time.split(':');

    final hour =
        int.tryParse(
              parts.isNotEmpty
                  ? parts[0]
                  : '0',
            ) ??
            0;

    final minute =
        int.tryParse(
              parts.length > 1
                  ? parts[1]
                  : '0',
            ) ??
            0;

    return DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
      hour,
      minute,
    );
  }

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}