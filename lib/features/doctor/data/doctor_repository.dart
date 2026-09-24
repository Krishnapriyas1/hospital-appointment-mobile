import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';
import 'package:hospital_appointment_mobile/core/network/api_client.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final ApiClient apiClient;

  DoctorRepository({
    required this.apiClient,
  });

  Future<List<DoctorModel>> getDoctors({
    String? category,
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': 1,
      'limit': 50,
    };

    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    final response = await apiClient.get(
      ApiConstants.doctors,
      queryParameters: queryParameters,
    );

    final data = response.data as Map<String, dynamic>;

    final doctorsJson = data['doctors'] as List<dynamic>? ?? [];

    return doctorsJson
        .map(
          (json) => DoctorModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<DoctorModel> getDoctorById(String id) async {
    final response = await apiClient.get(
      '${ApiConstants.doctors}/$id',
    );

    final data = response.data as Map<String, dynamic>;

    return DoctorModel.fromJson(
      data['doctor'] as Map<String, dynamic>,
    );
  }
}