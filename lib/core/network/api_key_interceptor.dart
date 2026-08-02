import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';

class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor({required this.apiKey});

  final String? apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      if (ApiEndpoints.requiresApiKey(options.path)) {
        options.headers['x-api-key'] = apiKey;
      }
    }
    super.onRequest(options, handler);
  }
}
