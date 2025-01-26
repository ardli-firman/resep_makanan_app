typedef FromJson<T> = T Function(Map<String, dynamic> json);

class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final String? error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    FromJson<T>? fromJson, // Ubah tipe parameter ini
  ) {
    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      data: fromJson != null && json['data'] != null
          ? fromJson(json['data'])
          : json['data'],
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
      error: json['error'],
    );
  }

  bool get isSuccess => status == 'success';
}
