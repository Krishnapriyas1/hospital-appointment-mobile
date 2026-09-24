import 'package:dio/dio.dart';
import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
  }) {
    return dio.post(
      path,
      data: data,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) {
    return dio.put(
      path,
      data: data,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
  }) {
    return dio.patch(
      path,
      data: data,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
  }) {
    return dio.delete(
      path,
      data: data,
    );
  }
}