import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bloodconnect/core/network/api_client.dart';
import 'package:bloodconnect/core/storage/secure_storage.dart';
import 'package:bloodconnect/models/user_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class AuthService {
  Future<UserModel> login(String email, String password) async {
    try {
      final resp = await ApiClient.I
          .post('/auth/login', data: {'email': email, 'password': password});
      debugPrint(
          'Login Response: Status ${resp.statusCode}, Body: ${jsonEncode(resp.data)}');
      final data = resp.data as Map<String, dynamic>;
      if (resp.statusCode != 200 || data.containsKey('error')) {
        throw Exception(
            data['error'] ?? 'Login failed with status ${resp.statusCode}');
      }
      final access = data['accessToken'] as String;
      final refresh = data['refreshToken'] as String;
      await SecureStorage.saveTokens(
          accessToken: access, refreshToken: refresh);
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await SecureStorage.saveUserJson(jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      debugPrint('Login Error: $e');
      if (e is DioException && e.response != null) {
        debugPrint('Error Details: ${jsonEncode(e.response!.data)}');
        throw Exception(
            e.response!.data['error'] ?? 'Network error during login');
      }
      throw Exception('Unexpected error: $e');
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final resp = await ApiClient.I.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'role': role,
      });
      debugPrint(
          'Register Response: Status ${resp.statusCode}, Body: ${jsonEncode(resp.data)}');
      final data = resp.data as Map<String, dynamic>;
      if (resp.statusCode != 200 || data.containsKey('error')) {
        throw Exception(data['error'] ??
            'Registration failed with status ${resp.statusCode}');
      }
      final access = data['accessToken'] as String;
      final refresh = data['refreshToken'] as String;
      await SecureStorage.saveTokens(
          accessToken: access, refreshToken: refresh);
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await SecureStorage.saveUserJson(jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      debugPrint('Register Error: $e');
      if (e is DioException && e.response != null) {
        debugPrint('Error Details: ${jsonEncode(e.response!.data)}');
        throw Exception(
            e.response!.data['error'] ?? 'Network error during registration');
      }
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    try {
      final refresh = await SecureStorage.refreshToken;
      if (refresh != null) {
        await ApiClient.I.post('/auth/logout', data: {'refreshToken': refresh});
      }
    } catch (_) {}
    await SecureStorage.clear();
  }

  Future<UserModel?> currentUser() async {
    final json = await SecureStorage.userJson;
    if (json == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}
