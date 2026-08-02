import 'package:dio/dio.dart';

import '../utils/app_exception.dart';

class NetworkErrorHandler {
  NetworkErrorHandler._();

  static AppException handleDioException(DioException exception) {
    final message = _getReadableMessage(exception);
    final statusCode = exception.response?.statusCode;

    // TODO: Capturar error y enviarlo a sistema de observabilidad o errores
    // logger.error('DioException: $message', error: exception);

    return AppException(message, statusCode: statusCode);
  }

  static String _getReadableMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'La solicitud tardó demasiado. Por favor, intenta de nuevo.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.unknown:
        return _handleUnknownError(exception);

      case DioExceptionType.cancel:
        return 'La solicitud fue cancelada.';

      case DioExceptionType.badCertificate:
        return 'Error de seguridad. Por favor, intenta de nuevo.';

      case DioExceptionType.connectionError:
        return 'Parece que hay un error en la conexión a internet. Por favor, verifica tu conexión.';
    }
  }

  static String _handleUnknownError(DioException exception) {
    final errorString = exception.error.toString().toLowerCase();
    if (errorString.contains('socket') || errorString.contains('connection')) {
      return 'Parece que hay un error en la conexión a internet. Por favor, verifica tu conexión.';
    }
    return 'Algo salió mal. Por favor, intenta de nuevo.';
  }

  static String _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;

    if (statusCode == null) {
      return 'Algo salió mal. Por favor, intenta de nuevo.';
    }

    if (statusCode >= 500) {
      return 'El servidor está experimentando problemas. Por favor, intenta de nuevo más tarde.';
    }

    if (statusCode == 404) {
      return 'El recurso solicitado no fue encontrado.';
    }

    if (statusCode == 401 || statusCode == 403) {
      return 'No tienes permiso para acceder a este recurso.';
    }

    if (statusCode >= 400) {
      return 'Algo salió mal. Por favor, intenta de nuevo.';
    }

    return 'Algo salió mal. Por favor, intenta de nuevo.';
  }
}

// Para facilitar importes en otros archivos
extension DioExceptionX on DioException {
  AppException toAppException() => NetworkErrorHandler.handleDioException(this);
}
