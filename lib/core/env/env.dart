import 'package:flutter/foundation.dart';

class AppEnv {
  // Prefer dart-define via --dart-define=API_BASE_URL=https://api.example.com
  // Cannot call trim in a const expression; keep raw value and normalize at use time
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get baseUrl {
    if (apiBaseUrl.isNotEmpty) return _normalize(apiBaseUrl);
    // Default for dev
    if (kIsWeb) {
      // When running on web, prefer same origin proxy or localhost:4000
      return 'http://localhost:4000/api';
    }
    return 'http://10.0.2.2:4000/api'; // Android emulator localhost
  }

  static String _normalize(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
