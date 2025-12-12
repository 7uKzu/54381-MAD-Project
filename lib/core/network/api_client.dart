import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:bloodconnect/core/env/env.dart';
import 'package:bloodconnect/core/storage/secure_storage.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._internal(this._dio);

  static ApiClient? _instance;
  static ApiClient get I => _instance ??= ApiClient._create();

  static ApiClient _create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppEnv.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await SecureStorage.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          debugPrint('Auth header error: $e');
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final retried = await _refreshAndRetry(dio, e.requestOptions);
          if (retried != null) return handler.resolve(retried);
        }
        handler.next(e);
      },
    ));

    return ApiClient._internal(dio);
  }

  Dio get raw => _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
  Future<Response<T>> post<T>(String path,
          {dynamic data, Map<String, dynamic>? query}) =>
      _dio.post(path, data: data, queryParameters: query);
  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  Future<Response<T>> delete<T>(String path, {dynamic data}) =>
      _dio.delete(path, data: data);

  static Future<Response<dynamic>?> _refreshAndRetry(
      Dio dio, RequestOptions req) async {
    try {
      final refresh = await SecureStorage.refreshToken;
      if (refresh == null) return null;
      final resp =
          await dio.post('/auth/refresh', data: {'refreshToken': refresh});
      final newAccess = resp.data['accessToken'] as String?;
      final newRefresh = resp.data['refreshToken'] as String? ?? refresh;
      if (newAccess == null) return null;
      await SecureStorage.saveTokens(
          accessToken: newAccess, refreshToken: newRefresh);
      final options = Options(
          method: req.method, headers: Map<String, dynamic>.from(req.headers));
      options.headers?['Authorization'] = 'Bearer $newAccess';
      return dio.request(req.path,
          data: req.data,
          queryParameters: req.queryParameters,
          options: options);
    } catch (e, st) {
      debugPrint('Refresh failed: $e\n$st');
      await SecureStorage.clear();
      return null;
    }
  }
}
