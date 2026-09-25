import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:hospital_appointment_mobile/core/constants/api_constant.dart';
import 'package:hospital_appointment_mobile/core/storage/token_storage.dart';

class ApiClient {
  late final Dio dio;

  final TokenStorage tokenStorage = TokenStorage();

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

    dio.interceptors.add(
      InterceptorsWrapper(
        // ===============================
        // ADD AUTH TOKEN
        // ===============================

        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();

          debugPrint(
            'API REQUEST: ${options.method} ${options.uri}',
          );

          debugPrint(
            'TOKEN EXISTS: ${token != null && token.isNotEmpty}',
          );

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer $token';
          }

          handler.next(options);
        },

        // ===============================
        // API ERROR
        // ===============================

        onError: (error, handler) {
          debugPrint(
            'API ERROR STATUS: ${error.response?.statusCode}',
          );

          debugPrint(
            'API ERROR RESPONSE: ${error.response?.data}',
          );

          handler.next(error);
        },
      ),
    );
  }

  // ===============================
  // GET
  // ===============================

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  // ===============================
  // POST
  // ===============================

  Future<Response> post(
    String path, {
    dynamic data,
  }) {
    return dio.post(
      path,
      data: data,
    );
  }

  // ===============================
  // PUT
  // ===============================

  Future<Response> put(
    String path, {
    dynamic data,
  }) {
    return dio.put(
      path,
      data: data,
    );
  }

  // ===============================
  // PATCH
  // ===============================

  Future<Response> patch(
    String path, {
    dynamic data,
  }) {
    return dio.patch(
      path,
      data: data,
    );
  }

  // ===============================
  // DELETE
  // ===============================

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
