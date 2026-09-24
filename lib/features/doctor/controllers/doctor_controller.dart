import 'package:get/get.dart';

import '../data/doctor_repository.dart';
import '../models/doctor_model.dart';

class DoctorController extends GetxController {
  final DoctorRepository repository;

  DoctorController({
    required this.repository,
  });

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final doctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors({
    String? category,
    String? search,
  }) async {
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

  String _getErrorMessage(Object error) {
    return error.toString().replaceFirst(
          'Exception: ',
          '',
        );
  }
}