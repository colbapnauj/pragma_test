import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'api_key_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio create({String? apiKey}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio.interceptors.add(ApiKeyInterceptor(apiKey: apiKey));

    return dio;
  }
}
