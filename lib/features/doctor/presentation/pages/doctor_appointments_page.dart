//FOR DOCTOR VIEWING THEIR APPOINTMENTS
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/doctor_appointment_controller.dart';
import '../../models/doctor_appointment_model.dart';

class DoctorAppointmentsPage
    extends StatefulWidget {
  const DoctorAppointmentsPage({
    super.key,
  });

  @override
  State<DoctorAppointmentsPage> createState() =>
      _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState
    extends State<DoctorAppointmentsPage> {
  final controller =
      Get.find<DoctorAppointmentController>();

  @override
  void initState() {
    super.initState();

    controller.loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF111827),
        elevation: 0,

        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.appointments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value
                .isNotEmpty &&
            controller.appointments.isEmpty) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(24),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (controller.appointments.isEmpty) {
          return const Center(
            child: Text(
              'No appointments found.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh:
              controller.loadAppointments,

          child: ListView.builder(
            padding:
                const EdgeInsets.all(20),

            itemCount:
                controller.appointments.length,

            itemBuilder:
                (context, index) {
              final appointment =
                  controller.appointments[index];

              return _appointmentCard(
                appointment,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _appointmentCard(
    DoctorAppointmentModel appointment,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/doctor-appointment-details',
          arguments: appointment,
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(bottom: 14),

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color:
                  Colors.black.withOpacity(0.04),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor:
                      const Color(0xFFE8F0FE),
                  child: const Icon(
                    Icons.person,
                    color:
                        Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName
                                .isEmpty
                            ? 'Patient'
                            : appointment
                                .patientName,
                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        appointment.patientEmail,
                        style:
                            const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
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

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color:
                      Color(0xFF2563EB),
                ),

                const SizedBox(width: 8),

                Text(
                  DateFormat(
                    'EEE, dd MMM yyyy',
                  ).format(
                    appointment.date,
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.access_time,
                  size: 18,
                  color:
                      Color(0xFF2563EB),
                ),

                const SizedBox(width: 6),

                Text(
                  appointment.time,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(
    String status,
  ) {
    final color =
        _statusColor(status);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status.capitalizeFirst ??
            status,

        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _statusColor(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      case 'upcoming':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}