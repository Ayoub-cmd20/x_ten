import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({this.code = 'unknown', this.message = ''});

  final String code;
  final String message;

  @override
  List<Object?> get props => [code, message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure() : super(code: 'network');
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.details = const {}})
      : super(code: 'validation_failed');

  final Map<String, dynamic> details;

  String? fieldError(String field) => switch (details[field]) {
        List l when l.isNotEmpty => l.first.toString(),
        String s => s,
        _ => null,
      };

  List<String> missingIn(String field) => switch (details[field]) {
        {'missing': List missing} => [for (final m in missing) m.toString()],
        _ => const [],
      };

  List<String> get missingDocuments => missingIn('documents');

  @override
  List<Object?> get props => [...super.props, details];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.code, super.message});
}

final class PermissionFailure extends Failure {
  const PermissionFailure({super.message}) : super(code: 'permission_denied');
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message}) : super(code: 'not_found');
}

final class ConflictFailure extends Failure {
  const ConflictFailure({super.message, this.currentStatus}) : super(code: 'conflict');

  final String? currentStatus;

  @override
  List<Object?> get props => [...super.props, currentStatus];
}

final class ThrottledFailure extends Failure {
  const ThrottledFailure({super.message, this.retryAfter}) : super(code: 'throttled');

  final int? retryAfter;

  @override
  List<Object?> get props => [...super.props, retryAfter];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.code, super.message, this.details = const {}});

  final Map<String, dynamic> details;

  @override
  List<Object?> get props => [...super.props, details];
}
