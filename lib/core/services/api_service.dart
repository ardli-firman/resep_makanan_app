import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan_app/core/exceptions/api_exception.dart';
import 'package:resep_makanan_app/core/models/login_model.dart';
import 'package:resep_makanan_app/core/utils/token_manager.dart';
import 'package:resep_makanan_app/core/models/api_response.dart';

class ApiService {
  final String baseUrl = 'https://recipe.incube.id';
  final TokenManager tokenManager;

  ApiService({required this.tokenManager});

  Future<String> _getToken() async {
    final token = await tokenManager.getToken();
    if (token == null) {
      return "";
    }
    return token;
  }

  Future<http.MultipartRequest> createMultipartRequest(
    String method,
    String endpoint,
    Map<String, String> fields,
    XFile file,
  ) async {
    final request = http.MultipartRequest(
      method,
      Uri.parse('$baseUrl/$endpoint'),
    );

    request.headers['Authorization'] = 'Bearer ${await _getToken()}';
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(
      'photo',
      file.path,
    ));

    return request;
  }

  Future<dynamic> handleMultipartRequest(http.MultipartRequest request) async {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final decodedBody = json.decode(responseBody);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      throw Exception(decodedBody['message'] ?? 'Request failed');
    }
  }

  ApiResponse<T> _handleResponse<T>(
      http.Response response, FromJson<T>? fromJson) {
    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.fromJson(responseBody, fromJson);
    } else {
      throw ApiException(
        message: responseBody['message'] ?? 'Request failed',
        statusCode: response.statusCode,
        errors: responseBody['errors'],
      );
    }
  }

  Future<ApiResponse<T>> get<T>(String endpoint,
      {FromJson<T>? fromJson}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
        'Content-Type': 'application/json',
      },
    );
    return _handleResponse(response, fromJson);
  }

  Future<ApiResponse<T>> post<T>(String endpoint, dynamic data,
      {FromJson<T>? fromJson}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse<T>(response, fromJson);
  }

  Future<ApiResponse<T>> put<T>(String endpoint, dynamic data,
      {FromJson<T>? fromJson}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return _handleResponse(response, fromJson);
  }

  Future<ApiResponse<T>> delete<T>(String endpoint,
      {FromJson<T>? fromJson}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
        'Content-Type': 'application/json',
      },
    );
    return _handleResponse(response, fromJson);
  }
}
