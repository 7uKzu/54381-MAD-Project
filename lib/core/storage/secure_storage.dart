import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _accessTokenKey = 'bc_access_token';
  static const _refreshTokenKey = 'bc_refresh_token';
  static const _userKey = 'bc_user_json';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> get accessToken async =>
      _storage.read(key: _accessTokenKey);
  static Future<String?> get refreshToken async =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userKey);
  }

  static Future<void> saveUserJson(String json) =>
      _storage.write(key: _userKey, value: json);
  static Future<String?> get userJson async => _storage.read(key: _userKey);
}
