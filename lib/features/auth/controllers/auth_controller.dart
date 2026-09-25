import 'package:get/get.dart';
import 'package:hospital_appointment_mobile/features/auth/data/auth_repository.dart';
import 'package:hospital_appointment_mobile/features/auth/models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController({
    required this.repository,
  });

  final isLoading = false.obs;
  final otpSent = false.obs;
  final errorMessage = ''.obs;

  final Rxn<UserModel> user = Rxn<UserModel>();

  Future<void> requestPatientOtp(String email) async {
    if (email.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await repository.requestPatientOtp(
        email: email,
      );

      otpSent.value = true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> verifyPatientOtp({
  required String email,
  required String otp,
}) async {
  if (isLoading.value) return;

  isLoading.value = true;
  errorMessage.value = '';

  try {
    final user = await repository.verifyPatientOtp(
      email: email.trim(),
      otp: otp.trim(),
    );

    final role = user.role.toLowerCase();

    if (role == 'patient') {
      Get.offAllNamed('/patient-home');
    } else if (role == 'doctor') {
      Get.offAllNamed('/doctor-home');
    } else if (role == 'admin') {
      Get.offAllNamed('/admin-home');
    } else {
      errorMessage.value = 'Unknown user role';
    }
  } catch (error) {
    errorMessage.value = error.toString().replaceFirst(
          'Exception: ',
          '',
        );

    Get.snackbar(
      'Error',
      errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
  }
}

Future<void> doctorLogin({
  required String username,
  required String password,
}) async {
  if (isLoading.value) return;

  if (username.trim().isEmpty || password.isEmpty) {
    errorMessage.value = 'Username and password are required';
    return;
  }

  isLoading.value = true;
  errorMessage.value = '';

  try {
    final loggedInUser = await repository.doctorLogin(
      username: username.trim(),
      password: password,
    );

    user.value = loggedInUser;

    final role = loggedInUser.role.toLowerCase();

    if (role == 'doctor') {
      Get.offAllNamed('/doctor-home');
    } else {
      errorMessage.value = 'This account is not a doctor account';
    }
  } catch (error) {
    errorMessage.value = _getErrorMessage(error);
  } finally {
    isLoading.value = false;
  }
}

  void resetOtp() {
    otpSent.value = false;
    errorMessage.value = '';
  }

  Future<void> logout() async {
  if (isLoading.value) return;

  try {
    isLoading.value = true;

    await repository.logout();

    user.value = null;
    otpSent.value = false;
    errorMessage.value = '';

    // Go back to role selection/login screen
    Get.offAllNamed('/');
  } catch (error) {
    errorMessage.value = _getErrorMessage(error);

    Get.snackbar(
      'Logout Failed',
      errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
    );
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