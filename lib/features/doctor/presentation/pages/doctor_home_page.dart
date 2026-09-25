import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment_mobile/features/doctor/controllers/doctor_appointment_controller.dart';

import '../../models/doctor_appointment_model.dart';
import '../../../auth/controllers/auth_controller.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({
    super.key,
  });

  @override
  State<DoctorHomePage> createState() =>
      _DoctorHomePageState();
}

class _DoctorHomePageState
    extends State<DoctorHomePage> {
  final DoctorAppointmentController controller =
      Get.find<DoctorAppointmentController>();

  final AuthController authController =
      Get.find<AuthController>();

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
        elevation: 0,

        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.appointments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh:
              controller.loadAppointments,

          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _welcomeCard(),

              const SizedBox(height: 22),

              _statistics(),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today\'s Appointments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF111827),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                        '/doctor-appointments',
                      );
                    },
                    child:
                        const Text('View All'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (controller
                  .todayAppointments
                  .isEmpty)
                _emptyToday()
              else
                ...controller
                    .todayAppointments
                    .take(3)
                    .map(
                      (appointment) =>
                          _appointmentCard(
                        appointment,
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  // =========================================================
  // WELCOME
  // =========================================================

  Widget _welcomeCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF1D4ED8),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                Colors.white24,
            child: Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Doctor',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Have a productive day!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STATISTICS
  // =========================================================

  Widget _statistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.today,
            title: 'Today',
            value: controller
                .todayAppointments
                .length
                .toString(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _statCard(
            icon: Icons.event_available,
            title: 'Upcoming',
            value: controller
                .upcomingAppointments
                .length
                .toString(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline,
            title: 'Completed',
            value: controller
                .completedAppointments
                .length
                .toString(),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2563EB),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // APPOINTMENT CARD
  // =========================================================

  Widget _appointmentCard(
    DoctorAppointmentModel appointment,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor:
                const Color(0xFFE8F0FE),
            child: const Icon(
              Icons.person,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  appointment.time,
                  style: const TextStyle(
                    color:
                        Color(0xFF2563EB),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                if (appointment.reason
                    .isNotEmpty)
                  Text(
                    appointment.reason,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              Get.toNamed(
                '/doctor-appointment-details',
                arguments: appointment,
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyToday() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 45,
            color: Colors.grey,
          ),

          SizedBox(height: 10),

          Text(
            'No appointments today',
            style: TextStyle(
              color: Colors.grey,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> _logout() async {
    final confirm =
        await Get.dialog<bool>(
      AlertDialog(
        title:
            const Text('Logout'),

        content: const Text(
          'Are you sure you want to logout?',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await authController.logout();

    Get.offAllNamed('/');
  }
}