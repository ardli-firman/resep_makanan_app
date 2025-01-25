import 'package:resep_makanan_app/core/services/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    return await apiService.post('api/register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await apiService.post('api/login', {
      'email': email,
      'password': password,
    });
  }

  Future<void> logout() async {
    await apiService.post('api/logout', {});
  }
}
