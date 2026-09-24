import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';
import 'package:hospital_appointment_mobile/core/network/api_client.dart';
import 'package:hospital_appointment_mobile/core/storage/token_storage.dart';
import 'package:hospital_appointment_mobile/features/auth/models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRepository({
    required this.apiClient,
    required this.tokenStorage,
  });

  // =========================
  // PATIENT - REQUEST OTP
  // =========================

  Future<void> requestPatientOtp({
  required String email,
}) async {
  await apiClient.post(
    ApiConstants.patientRequestOtp,
    data: {
      'email': email.trim().toLowerCase(),
    },
  );
}

  // =========================
  // PATIENT - VERIFY OTP
  // =========================

  Future<UserModel> verifyPatientOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiClient.post(
      ApiConstants.patientVerifyOtp,
      data: {
        'email': email.trim().toLowerCase(),
        'otp': otp.trim(),
      },
    );

    final data = response.data as Map<String, dynamic>;

    final token = data['token']?.toString() ?? '';

    final user = UserModel.fromJson(
      data['user'] as Map<String, dynamic>,
    );

    await tokenStorage.saveToken(token);
    await tokenStorage.saveRole(user.role);

    return user;
  }

  // =========================
  // DOCTOR LOGIN
  // =========================

  Future<UserModel> doctorLogin({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiConstants.doctorLogin,
      data: {
        'username': username.trim().toLowerCase(),
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;

    final token = data['token']?.toString() ?? '';

    final user = UserModel.fromJson(
      data['user'] as Map<String, dynamic>,
    );

    await tokenStorage.saveToken(token);
    await tokenStorage.saveRole(user.role);

    return user;
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await tokenStorage.clear();
  }
}