class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    final err = errors?.values.expand((v) => v).join('\n') ?? message;
    return "$message\n\n$err";
  }
}
