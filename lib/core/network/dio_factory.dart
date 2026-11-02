import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:x_ten/core/config/env.dart';
import 'package:x_ten/core/constants/app_constants.dart';
import 'package:x_ten/core/network/interceptors/auth_interceptor.dart';
import 'package:x_ten/core/network/interceptors/envelope_interceptor.dart';
import 'package:x_ten/core/network/interceptors/locale_interceptor.dart';
import 'package:x_ten/core/network/interceptors/log_interceptor.dart';
import 'package:x_ten/core/session/session_notifier.dart';
import 'package:x_ten/core/storage/app_preferences.dart';
import 'package:x_ten/core/storage/token_storage.dart';

abstract final class DioFactory {
  static Dio create({
    required TokenStorage storage,
    required SessionNotifier session,
    required AppPreferences preferences,
  }) {
    final options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Accept': 'application/json'},
    );

    final plainDio = Dio(options)..interceptors.addAll(_common(preferences));

    return Dio(options)
      ..interceptors.add(
        AuthInterceptor(plainDio: plainDio, storage: storage, session: session),
      )
      ..interceptors.addAll(_common(preferences));
  }

  static List<Interceptor> _common(AppPreferences preferences) => [
        LocaleInterceptor(preferences),
        EnvelopeInterceptor(),
        if (kDebugMode) AppLogInterceptor(),
      ];
}
