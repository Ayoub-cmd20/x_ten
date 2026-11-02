import 'package:dio/dio.dart';
import 'package:x_ten/core/errors/api_error.dart';
import 'package:x_ten/core/errors/exceptions.dart';
import 'package:x_ten/core/errors/failures.dart';

extension DioExceptionX on DioException {
  AppException toAppException() => switch (type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          const NetworkException(),
        DioExceptionType.badResponse => ServerException(
            response?.statusCode,
            ApiError.fromResponse(response?.data),
            retryAfter: int.tryParse(response?.headers.value('retry-after') ?? ''),
          ),
        _ => UnexpectedException(this),
      };
}

extension AppExceptionX on AppException {
  Failure toFailure() => switch (this) {
        NetworkException() => const NetworkFailure(),
        UnexpectedException() => const ServerFailure(),
        ServerException(:final error, :final retryAfter) => _fromApiError(error, retryAfter),
      };
}

Failure _fromApiError(ApiError error, int? retryAfter) => switch (error.code) {
      'validation_failed' => ValidationFailure(message: error.message, details: error.details),
      'not_authenticated' || 'token_not_valid' || 'authentication_failed' =>
        UnauthorizedFailure(code: error.code, message: error.message),
      'permission_denied' => PermissionFailure(message: error.message),
      'not_found' => NotFoundFailure(message: error.message),
      'conflict' => ConflictFailure(
          message: error.message,
          currentStatus: error.details['status'] as String?,
        ),
      'throttled' => ThrottledFailure(
          message: error.message,
          retryAfter: retryAfter ?? _secondsIn(error.message),
        ),
      _ => ServerFailure(code: error.code, message: error.message, details: error.details),
    };

int? _secondsIn(String message) =>
    int.tryParse(RegExp(r'\d+').firstMatch(message)?.group(0) ?? '');
