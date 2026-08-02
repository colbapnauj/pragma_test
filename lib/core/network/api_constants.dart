class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const String apiKeyHeader = 'x-api-key';
  static const String? apiKey = null;
}
