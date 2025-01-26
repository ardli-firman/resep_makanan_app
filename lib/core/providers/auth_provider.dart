import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:resep_makanan_app/core/services/auth_service.dart';
import 'package:resep_makanan_app/core/utils/token_manager.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final TokenManager _tokenManager;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider({
    required AuthService authService,
    required TokenManager tokenManager,
  })  : _authService = authService,
        _tokenManager = tokenManager;

  Future<void> checkAuthentication() async {
    final token = await _tokenManager.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _startLoading();
      final response = await _authService.register(name, email, password);
      if (response.isSuccess && response.data != null) {
        await _tokenManager.saveToken(response.data!['token']);
      } else {
        _setError(response.message);
        throw Exception(response.message);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _startLoading();
      final response = await _authService.login(email, password);
      if (response.isSuccess && response.data != null) {
        await _tokenManager.saveToken(response.data!.token ?? "");
        _isAuthenticated = true;
      } else {
        _setError(response.message);
        throw Exception(response.message);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      await _authService.logout();
      await _tokenManager.clearToken();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
