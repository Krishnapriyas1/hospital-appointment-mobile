import 'package:get/get.dart';

import '../data/appointment_repository.dart';
import '../models/appointment_model.dart';

class AppointmentController extends GetxController {
  final AppointmentRepository repository;

  AppointmentController({
    required this.repository,
  });

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final appointments = <AppointmentModel>[].obs;

  // ============================================================
  // LOAD MY APPOINTMENTS
  // ============================================================

  Future<void> loadMyAppointments() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await repository.getMyAppointments();

      appointments.assignAll(result);
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // BOOK APPOINTMENT
  // ============================================================

  Future<bool> bookAppointment({
    required String doctorId,
    required DateTime date,
    required String time,
    String reason = '',
  }) async {
    if (isLoading.value) {
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await repository.bookAppointment(
        doctorId: doctorId,
        date: date,
        time: time,
        reason: reason,
      );

      // Reload appointments after successful booking
      await loadMyAppointments();

      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CANCEL APPOINTMENT
  // ============================================================

  Future<bool> cancelAppointment(String id) async {
    if (isLoading.value) {
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await repository.cancelAppointment(id);

      // Reload appointments after cancellation
      await loadMyAppointments();

      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPCOMING APPOINTMENTS
  // ============================================================

  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();

    final result = appointments.where((appointment) {
      // Cancelled and completed appointments
      // should not appear in upcoming.
      if (appointment.status.toLowerCase() == 'cancelled' ||
          appointment.status.toLowerCase() == 'completed') {
        return false;
      }

      final appointmentDateTime =
          _getAppointmentDateTime(appointment);

      return appointmentDateTime.isAfter(now);
    }).toList();

    // Sort nearest appointment first
    result.sort((a, b) {
      return _getAppointmentDateTime(a).compareTo(
        _getAppointmentDateTime(b),
      );
    });

    return result;
  }

  // ============================================================
  // PAST APPOINTMENTS
  // ============================================================

  List<AppointmentModel> get pastAppointments {
    final now = DateTime.now();

    final result = appointments.where((appointment) {
      final status = appointment.status.toLowerCase();

      // Completed appointments are always past.
      if (status == 'completed') {
        return true;
      }

      // Cancelled appointments are shown separately.
      if (status == 'cancelled') {
        return false;
      }

      final appointmentDateTime =
          _getAppointmentDateTime(appointment);

      return appointmentDateTime.isBefore(now);
    }).toList();

    // Most recent past appointment first
    result.sort((a, b) {
      return _getAppointmentDateTime(b).compareTo(
        _getAppointmentDateTime(a),
      );
    });

    return result;
  }

  // ============================================================
  // CANCELLED APPOINTMENTS
  // ============================================================

  List<AppointmentModel> get cancelledAppointments {
    return appointments.where((appointment) {
      return appointment.status.toLowerCase() == 'cancelled';
    }).toList();
  }

  // ============================================================
  // GET APPOINTMENT DATE + TIME
  // ============================================================

  DateTime _getAppointmentDateTime(
    AppointmentModel appointment,
  ) {
    final timeParts = appointment.time.split(':');

    final hour = int.tryParse(
          timeParts.isNotEmpty
              ? timeParts[0]
              : '0',
        ) ??
        0;

    final minute = int.tryParse(
          timeParts.length > 1
              ? timeParts[1]
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

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}
