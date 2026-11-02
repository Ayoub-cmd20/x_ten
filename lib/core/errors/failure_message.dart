import 'package:flutter/widgets.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';

extension FailureMessage on Failure {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      NetworkFailure() => l10n.errorNetwork,
      ThrottledFailure(:final retryAfter?) => l10n.errorThrottled(retryAfter),
      ThrottledFailure() => l10n.errorThrottledGeneric,
      UnauthorizedFailure(code: 'authentication_failed') => l10n.errorInvalidCredentials,
      UnauthorizedFailure() => l10n.errorSessionExpired,
      PermissionFailure() => l10n.errorPermission,
      NotFoundFailure() => l10n.errorNotFound,
      ConflictFailure() => l10n.errorConflict,
      ValidationFailure() => l10n.errorValidation,
      ServerFailure() => l10n.errorUnexpected,
    };
  }
}
