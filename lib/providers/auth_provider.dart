import 'package:flutter/foundation.dart';
import 'package:bloodconnect/models/user_model.dart';
import 'package:bloodconnect/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  UserModel? _user;
  bool _loading = false;
  String? _error;

  AuthProvider(this._service);

  UserModel? get user => _user;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> init() async {
    _user = await _service.currentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _service.login(email, password);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Login failed';
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(
      String email, String password, String name, String role) async {
    _setLoading(true);
    try {
      _user = await _service.register(
          email: email, password: password, fullName: name, role: role);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Registration failed';
      debugPrint('Register error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
