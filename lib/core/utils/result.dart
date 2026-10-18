import 'package:flutter/foundation.dart';
import 'package:x_ten/core/errors/error_mapper.dart';
import 'package:x_ten/core/errors/exceptions.dart';
import 'package:x_ten/core/errors/failures.dart';

sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}

Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Ok(await action());
  } on AppException catch (e) {
    return Err(e.toFailure());
  } catch (e, stack) {
    if (kDebugMode) debugPrint('guard caught $e\n$stack');
    return Err(UnexpectedException(e).toFailure());
  }
}
