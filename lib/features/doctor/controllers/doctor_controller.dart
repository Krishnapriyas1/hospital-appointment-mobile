import 'package:get/get.dart';

import '../data/doctor_repository.dart';
import '../models/doctor_model.dart';

class DoctorController extends GetxController {
  final DoctorRepository repository;

  DoctorController({
    required this.repository,
  });

  // =========================
  // LOADING STATES
  // =========================

  final isLoading = false.obs;
  final isDetailsLoading = false.obs;

  // =========================
  // ERROR
  // =========================

  final errorMessage = ''.obs;

  // =========================
  // DATA
  // =========================

  final selectedDoctor = Rxn<DoctorModel>();

  final doctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadDoctors();
  }

  // =========================
  // LOAD ALL DOCTORS
  // =========================

  Future<void> loadDoctors({
    String? category,
    String? search,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await repository.getDoctors(
        category: category,
        search: search,
      );

      doctors.assignAll(result);
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOAD DOCTOR DETAILS
  // =========================

  Future<void> loadDoctorDetails(String id) async {
    if (isDetailsLoading.value) return;

    isDetailsLoading.value = true;
    errorMessage.value = '';
    selectedDoctor.value = null;

    try {
      final doctor = await repository.getDoctorById(id);

      selectedDoctor.value = doctor;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
    } finally {
      isDetailsLoading.value = false;
    }
  }

  // =========================
  // ERROR MESSAGE
  // =========================

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}