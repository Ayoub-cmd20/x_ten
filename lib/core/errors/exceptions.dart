import 'package:x_ten/core/errors/api_error.dart';

sealed class AppException implements Exception {
  const AppException();
}

final class ServerException extends AppException {
  const ServerException(this.statusCode, this.error, {this.retryAfter});

  final int? statusCode;
  final ApiError error;
  final int? retryAfter;
}

final class NetworkException extends AppException {
  const NetworkException();
}

final class UnexpectedException extends AppException {
  const UnexpectedException(this.cause);

  final Object cause;
}
