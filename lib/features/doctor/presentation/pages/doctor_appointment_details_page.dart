import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/doctor_appointment_controller.dart';
import '../../models/doctor_appointment_model.dart';

class DoctorAppointmentDetailsPage
    extends StatelessWidget {
  DoctorAppointmentDetailsPage({
    super.key,
  });

  final controller =
      Get.find<DoctorAppointmentController>();

  @override
  Widget build(BuildContext context) {
    final appointment =
        Get.arguments as DoctorAppointmentModel;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF111827),
        elevation: 0,

        title: const Text(
          'Appointment Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _patientCard(
              appointment,
            ),

            const SizedBox(height: 20),

            _informationCard(
              appointment,
            ),

            const SizedBox(height: 25),

            const Text(
              'Appointment Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            Obx(
              () => _statusButtons(
                appointment,
                controller.isUpdating.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PATIENT
  // =========================================================

  Widget _patientCard(
    DoctorAppointmentModel appointment,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF1D4ED8),
          ],
        ),

        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor:
                Colors.white24,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            appointment.patientName
                    .isEmpty
                ? 'Patient'
                : appointment
                    .patientName,

            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            appointment.patientEmail
                    .isEmpty
                ? 'Email not available'
                : appointment
                    .patientEmail,

            style:
                const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFORMATION
  // =========================================================

  Widget _informationCard(
    DoctorAppointmentModel appointment,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          _infoRow(
            Icons.phone_outlined,
            'Phone',
            appointment
                .patientPhone,
          ),

          const Divider(height: 25),

          _infoRow(
            Icons.calendar_today_outlined,
            'Date',
            DateFormat(
              'EEE, dd MMM yyyy',
            ).format(
              appointment.date,
            ),
          ),

          const Divider(height: 25),

          _infoRow(
            Icons.access_time,
            'Time',
            appointment.time,
          ),

          if (appointment
              .reason
              .isNotEmpty) ...[
            const Divider(height: 25),

            _infoRow(
              Icons.notes_outlined,
              'Reason',
              appointment.reason,
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          padding:
              const EdgeInsets.all(9),

          decoration: BoxDecoration(
            color:
                const Color(0xFFE8F0FE),
            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Icon(
            icon,
            color:
                const Color(0xFF2563EB),
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value.isEmpty
                    ? 'Not available'
                    : value,

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // STATUS BUTTONS
  // =========================================================

  Widget _statusButtons(
    DoctorAppointmentModel appointment,
    bool isUpdating,
  ) {
    if (isUpdating) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    final current =
        appointment.status
            .toLowerCase();

    return Column(
      children: [
        if (current != 'confirmed')
          _statusButton(
            title:
                'Confirm Appointment',
            icon:
                Icons.check_circle_outline,
            color: Colors.green,
            onPressed: () =>
                _updateStatus(
              appointment,
              'confirmed',
            ),
          ),

        if (current != 'completed')
          _statusButton(
            title:
                'Mark as Completed',
            icon:
                Icons.done_all,
            color:
                const Color(0xFF2563EB),
            onPressed: () =>
                _updateStatus(
              appointment,
              'completed',
            ),
          ),

        if (current != 'cancelled')
          _statusButton(
            title:
                'Cancel Appointment',
            icon:
                Icons.cancel_outlined,
            color: Colors.red,
            onPressed: () =>
                _confirmCancel(
              appointment,
            ),
          ),
      ],
    );
  }

  Widget _statusButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      height: 52,

      child: ElevatedButton.icon(
        onPressed: onPressed,

        icon: Icon(icon),

        label: Text(
          title,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        style:
            ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor:
              Colors.white,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // UPDATE
  // =========================================================

  Future<void> _updateStatus(
    DoctorAppointmentModel appointment,
    String status,
  ) async {
    final success =
        await controller.updateStatus(
      appointmentId:
          appointment.id,
      status: status,
    );

    if (success) {
      Get.snackbar(
        'Success',
        'Appointment status updated',
        snackPosition:
            SnackPosition.BOTTOM,
        backgroundColor:
            Colors.green,
        colorText:
            Colors.white,
      );

      Get.back();
    } else {
      Get.snackbar(
        'Error',
        controller
            .errorMessage.value,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // =========================================================
  // CANCEL CONFIRMATION
  // =========================================================

  Future<void> _confirmCancel(
    DoctorAppointmentModel appointment,
  ) async {
    final confirm =
        await Get.dialog<bool>(
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
              Get.back(
                result: false,
              );
            },
            child:
                const Text('No'),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(
                result: true,
              );
            },
            child:
                const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    await _updateStatus(
      appointment,
      'cancelled',
    );
  }
}