import 'package:flutter/foundation.dart';
import 'package:resep_makanan_app/core/services/auth_service.dart';
import 'package:resep_makanan_app/core/utils/token_manager.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final TokenManager _tokenManager;

  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    required AuthService authService,
    required TokenManager tokenManager,
  })  : _authService = authService,
        _tokenManager = tokenManager;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _tokenManager.getToken() != null;

  Future<void> register(String name, String email, String password) async {
    _startLoading();
    try {
      final response = await _authService.register(name, email, password);
      await _tokenManager.saveToken(response['token']);
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  Future<void> login(String email, String password) async {
    _startLoading();
    try {
      final response = await _authService.login(email, password);
      await _tokenManager.saveToken(response['token']);
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  Future<void> logout() async {
    _startLoading();
    try {
      await _authService.logout();
      await _tokenManager.clearToken();
      _clearError();
    } catch (e) {
      _setError(e.toString());
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
