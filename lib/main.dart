import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment_mobile/features/appointment/controllers/appointment_controller.dart';
import 'package:hospital_appointment_mobile/features/appointment/data/appointment_repository.dart';
import 'package:hospital_appointment_mobile/features/auth/presentation/pages/starting_page.dart';
import 'package:hospital_appointment_mobile/features/doctor/controllers/doctor_appointment_controller.dart';
import 'package:hospital_appointment_mobile/features/doctor/data/doctor_appointment_repository.dart';
import 'package:hospital_appointment_mobile/features/doctor/presentation/pages/doctor_appointment_details_page.dart';
import 'package:hospital_appointment_mobile/features/doctor/presentation/pages/doctor_appointments_page.dart';
import 'features/appointment/presentation/my_appointments_page.dart';
import 'features/auth/presentation/pages/doctor_login_page.dart';
import 'features/auth/presentation/pages/role_selection_page.dart';
import 'features/doctor/presentation/pages/doctor_details_page.dart';
import 'features/doctor/presentation/pages/doctor_home_page.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';

import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/data/auth_repository.dart';

import 'features/auth/presentation/pages/patient_login_page.dart';
import 'features/auth/presentation/pages/patient_home_page.dart';

import 'features/doctor/controllers/doctor_controller.dart';
import 'features/doctor/data/doctor_repository.dart';
import 'features/doctor/presentation/pages/doctor_list_page.dart';

void main() {
  final apiClient = ApiClient();

  final tokenStorage = TokenStorage();

  final authRepository = AuthRepository(
    apiClient: apiClient,
    tokenStorage: tokenStorage,
  );

  Get.put(AuthController(repository: authRepository));

  final doctorRepository = DoctorRepository(apiClient: apiClient);

  Get.put(DoctorController(repository: doctorRepository));

  final appointmentRepository = AppointmentRepository(apiClient: apiClient);

  Get.put(AppointmentController(repository: appointmentRepository));
  //DOCTOR
  final doctorAppointmentRepository = DoctorAppointmentRepository(
    apiClient: apiClient,
  );

  Get.put(DoctorAppointmentController(repository: doctorAppointmentRepository));

  runApp(const HospitalAppointmentApp());
}

class HospitalAppointmentApp extends StatelessWidget {
  const HospitalAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Appointment',

      initialRoute: '/',

getPages: [
  GetPage(
    name: '/',
    page: () =>  StartingPage(),
  ),

  GetPage(
    name: '/roleselecting',
    page: () => const RoleSelectionPage(),
  ),
        // PATIENT LOGIN
        GetPage(name: '/patient-login', page: () => const PatientLoginPage()),

        // DOCTOR LOGIN
        GetPage(name: '/doctor-login', page: () => DoctorLoginPage()),
        // PATIENT HOME
        GetPage(name: '/patient-home', page: () => const PatientHomePage()),

        // DOCTOR HOME
        GetPage(name: '/doctor-home', page: () => const DoctorHomePage()),

        GetPage(
          name: '/my-appointments',
          page: () => const MyAppointmentsPage(),
        ),
        GetPage(name: '/doctors', page: () => const DoctorListPage()),

        GetPage(
          name: '/doctor-details/:id',
          page: () => DoctorDetailsPage(doctorId: Get.parameters['id']!),
        ),
        GetPage(
  name: '/doctor-appointments',
  page: () =>
      const DoctorAppointmentsPage(),
),

GetPage(
  name: '/doctor-appointment-details',
  page: () =>
      DoctorAppointmentDetailsPage(),
),
      ],
    );
  }
}
