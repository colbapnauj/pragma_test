import 'package:dio/dio.dart';

import 'api_constants.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    final apiKey = ApiConstants.apiKey;
    if (apiKey != null && apiKey.isNotEmpty) {
      dio.options.headers[ApiConstants.apiKeyHeader] = apiKey;
    }

    return dio;
  }
}
