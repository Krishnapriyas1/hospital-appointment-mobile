import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hospital_appointment_mobile/features/appointment/controllers/appointment_controller.dart';
import 'package:hospital_appointment_mobile/features/appointment/models/appointment_model.dart';
import 'package:hospital_appointment_mobile/features/auth/controllers/auth_controller.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final AppointmentController appointmentController =
      Get.find<AppointmentController>();

  final AuthController authController =
      Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    _loadAppointments();
  }

  // ============================================================
  // LOAD APPOINTMENTS
  // ============================================================

  Future<void> _loadAppointments() async {
    await appointmentController.loadMyAppointments();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Patient Home',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'No new notifications',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF111827),
            ),
          ),

          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog();
            },
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAppointments,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // WELCOME
                // ==================================================

                const Text(
                  'Welcome 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Find the right doctor for your healthcare needs.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // SEARCH
                // ==================================================

                TextField(
                  readOnly: true,
                  onTap: () async {
                    await Get.toNamed('/doctors');

                    // Reload appointments when returning
                    // from doctor/booking screen.
                    await _loadAppointments();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search doctors...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // QUICK ACTIONS
                // ==================================================

                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _actionCard(
                        icon: Icons.medical_services_outlined,
                        title: 'Find Doctor',
                        onTap: () async {
                          await Get.toNamed('/doctors');

                          // IMPORTANT:
                          // When the patient books an appointment
                          // and comes back, reload appointments.
                          await _loadAppointments();
                        },
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: _actionCard(
                        icon: Icons.calendar_month_outlined,
                        title: 'My Appointments',
                        onTap: () async {
                          await Get.toNamed('/my-appointments');

                          // Reload when coming back.
                          await _loadAppointments();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ==================================================
                // UPCOMING APPOINTMENT
                // ==================================================

                const Text(
                  'Upcoming Appointment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() {
                  final appointments =
                      appointmentController.appointments;

                  // ------------------------------------------------
                  // LOADING
                  // ------------------------------------------------

                  if (appointmentController.isLoading.value &&
                      appointments.isEmpty) {
                    return _loadingAppointmentCard();
                  }

                  // ------------------------------------------------
                  // USE CONTROLLER'S UPCOMING APPOINTMENTS
                  // ------------------------------------------------

                  final upcomingAppointments =
                      appointmentController.upcomingAppointments;

                  if (upcomingAppointments.isEmpty) {
                    return _emptyAppointmentCard();
                  }

                  // First upcoming appointment.
                  final upcomingAppointment =
                      upcomingAppointments.first;

                  return _upcomingAppointmentCard(
                    upcomingAppointment,
                  );
                }),

                const SizedBox(height: 28),

                // ==================================================
                // POPULAR CATEGORIES
                // ==================================================

                const Text(
                  'Popular Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _categoryCard(
                        icon: Icons.favorite_outline,
                        title: 'Cardiology',
                      ),
                      _categoryCard(
                        icon: Icons.psychology_outlined,
                        title: 'Neurology',
                      ),
                      _categoryCard(
                        icon: Icons.child_care,
                        title: 'Pediatrics',
                      ),
                      _categoryCard(
                        icon: Icons.health_and_safety_outlined,
                        title: 'General',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
            await Get.toNamed('/doctors');

            await _loadAppointments();
          }

          if (index == 2) {
            await Get.toNamed('/my-appointments');

            await _loadAppointments();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Appointments',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPCOMING APPOINTMENT CARD
  // ============================================================

  Widget _upcomingAppointmentCard(
    AppointmentModel appointment,
  ) {
    final doctorName = appointment.doctorName.isNotEmpty
        ? appointment.doctorName
        : 'Doctor';

    final specialization = appointment.specialization;

    final date = appointment.date;

    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    final time = appointment.time;

    final status = appointment.status.isNotEmpty
        ? appointment.status
        : 'confirmed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // DOCTOR INFORMATION
          // ========================================================

          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFE0ECFF),
                backgroundImage:
                    appointment.doctorImage.isNotEmpty
                        ? NetworkImage(
                            appointment.doctorImage,
                          )
                        : null,
                child: appointment.doctorImage.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Color(0xFF2563EB),
                      )
                    : null,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    if (specialization.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        specialization,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ====================================================
              // STATUS
              // ====================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusBackgroundColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _statusTextColor(status),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(),

          const SizedBox(height: 12),

          // ========================================================
          // DATE & TIME
          // ========================================================

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 19,
                color: Color(0xFF2563EB),
              ),

              const SizedBox(width: 10),

              Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(width: 20),

              const Icon(
                Icons.access_time_outlined,
                size: 19,
                color: Color(0xFF2563EB),
              ),

              const SizedBox(width: 8),

              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================================================
          // VIEW APPOINTMENT
          // ========================================================

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () async {
                await Get.toNamed('/my-appointments');

                await _loadAppointments();
              },
              child: const Text(
                'View Appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BACKGROUND COLOR
  // ============================================================

  Color _statusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade50;

      case 'upcoming':
        return Colors.blue.shade50;

      case 'completed':
        return Colors.grey.shade200;

      case 'cancelled':
        return Colors.red.shade50;

      default:
        return Colors.green.shade50;
    }
  }

  // ============================================================
  // STATUS TEXT COLOR
  // ============================================================

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade700;

      case 'upcoming':
        return Colors.blue.shade700;

      case 'completed':
        return Colors.grey.shade700;

      case 'cancelled':
        return Colors.red.shade700;

      default:
        return Colors.green.shade700;
    }
  }

  // ============================================================
  // LOADING APPOINTMENT CARD
  // ============================================================

  Widget _loadingAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ============================================================
  // EMPTY APPOINTMENT CARD
  // ============================================================

  Widget _emptyAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFE0ECFF),
            child: Icon(
              Icons.person,
              color: Color(0xFF2563EB),
            ),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'No upcoming appointment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Book an appointment with a doctor.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _actionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 38,
              color: const Color(0xFF2563EB),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _categoryCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 34,
            color: const Color(0xFF2563EB),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _showLogoutDialog() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authController.logout();
    }
  }
}