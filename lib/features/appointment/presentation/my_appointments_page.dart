import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment_mobile/features/appointment/controllers/appointment_controller.dart';
import 'package:hospital_appointment_mobile/features/appointment/models/appointment_model.dart';
import 'package:intl/intl.dart';


class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({
    super.key,
  });

  @override
  State<MyAppointmentsPage> createState() =>
      _MyAppointmentsPageState();
}

class _MyAppointmentsPageState
    extends State<MyAppointmentsPage> {
  final AppointmentController controller =
      Get.find<AppointmentController>();

  @override
  void initState() {
    super.initState();

    controller.loadMyAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Get.offAllNamed('/patient-home'),
  ),
        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.appointments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.appointments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final upcoming =
            controller.upcomingAppointments;

        final past =
            controller.pastAppointments;

        final cancelled =
            controller.cancelledAppointments;

        if (upcoming.isEmpty &&
            past.isEmpty &&
            cancelled.isEmpty) {
          return const Center(
            child: Text(
              'No appointments found.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh:
              controller.loadMyAppointments,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (upcoming.isNotEmpty) ...[
                _sectionTitle(
                  'Upcoming Appointments',
                ),
                const SizedBox(height: 12),
                ...upcoming.map(
                  (appointment) =>
                      _appointmentCard(
                    appointment,
                    canCancel: true,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              if (past.isNotEmpty) ...[
                _sectionTitle(
                  'Past Appointments',
                ),
                const SizedBox(height: 12),
                ...past.map(
                  (appointment) =>
                      _appointmentCard(
                    appointment,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              if (cancelled.isNotEmpty) ...[
                _sectionTitle(
                  'Cancelled Appointments',
                ),
                const SizedBox(height: 12),
                ...cancelled.map(
                  (appointment) =>
                      _appointmentCard(
                    appointment,
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _appointmentCard(
    AppointmentModel appointment, {
    bool canCancel = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _doctorImage(
                appointment.doctorImage,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.specialization,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                appointment.status,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat(
                  'EEE, dd MMM yyyy',
                ).format(appointment.date),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 8),
              Text(
                appointment.time,
              ),
            ],
          ),

          if (appointment.reason.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notes_outlined,
                  size: 18,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.reason,
                  ),
                ),
              ],
            ),
          ],

          if (canCancel) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  _cancelAppointment(
                    appointment,
                  );
                },
                child: const Text(
                  'Cancel Appointment',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _doctorImage(String image) {
    if (image.isEmpty) {
      return const CircleAvatar(
        radius: 27,
        backgroundColor: Color(0xFFE0ECFF),
        child: Icon(
          Icons.person,
          color: Color(0xFF2563EB),
        ),
      );
    }

    return CircleAvatar(
      radius: 27,
      backgroundImage: NetworkImage(image),
      onBackgroundImageError: (_, __) {},
      backgroundColor:
          const Color(0xFFE0ECFF),
      child: null,
    );
  }

  Widget _statusBadge(String status) {
    String text = status;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusColor(status)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.capitalizeFirst ?? text,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;

      case 'upcoming':
        return Colors.blue;

      case 'completed':
        return Colors.grey;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  Future<void> _cancelAppointment(
    AppointmentModel appointment,
  ) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Cancel Appointment',
        ),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final success =
        await controller.cancelAppointment(
      appointment.id,
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Appointment cancelled successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        controller.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
