import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppLogInterceptor extends Interceptor {
  static const _hidden = {'password', 'newPassword', 'access', 'refresh', 'otp', 'registrationToken'};
  static const _maxLength = 2000;
  static const _encoder = JsonEncoder.withIndent('  ', _fallback);

  static Object? _fallback(Object? value) => '$value';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('→ ${options.method} ${options.uri}${_body(options.data)}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;
    debugPrint('← ${response.statusCode} ${request.method} ${request.uri}${_body(response.data)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    final status = err.response?.statusCode?.toString() ?? err.type.name;
    debugPrint('✕ $status ${request.method} ${request.uri}${_body(err.response?.data)}');
    handler.next(err);
  }

  static String _body(Object? data) {
    if (data == null) return '';
    if (data is FormData) {
      return '\n[form-data: ${data.fields.length} fields, ${data.files.length} files]';
    }
    final redacted = _redact(data);
    final text = redacted is String ? redacted : _encoder.convert(redacted);
    return '\n${text.length > _maxLength ? '${text.substring(0, _maxLength)}…' : text}';
  }

  static Object? _redact(Object? value) => switch (value) {
        Map() => {
            for (final entry in value.entries)
              '${entry.key}': _hidden.contains(entry.key) ? '••••' : _redact(entry.value),
          },
        List() => [for (final item in value) _redact(item)],
        _ => value,
      };
}
