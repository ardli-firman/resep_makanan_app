import 'package:resep_makanan_app/core/models/login_model.dart';
import 'package:resep_makanan_app/core/services/api_service.dart';
import 'package:resep_makanan_app/core/utils/token_manager.dart';
import 'package:resep_makanan_app/core/models/api_response.dart';

class AuthService {
  final ApiService apiService;
  final TokenManager tokenManager;

  AuthService({required this.apiService, required this.tokenManager});

  Future<ApiResponse<Map<String, dynamic>>> register(
    String name,
    String email,
    String password,
  ) async {
    return await apiService.post<Map<String, dynamic>>(
      'api/register',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<ApiResponse<LoginModel>> login(
    String email,
    String password,
  ) async {
    final response = await apiService.post<LoginModel>(
      'api/login',
      {
        'email': email,
        'password': password,
      },
      fromJson: LoginModel.fromJson,
    );

    return response;
  }

  Future<ApiResponse<void>> logout() async {
    final response = await apiService.post<void>(
      'api/logout',
      {},
    );
    await tokenManager.clearToken();
    return response;
  }
}
