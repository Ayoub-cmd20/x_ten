import 'package:dio/dio.dart';
import 'package:x_ten/core/localization/locale_cubit.dart';
import 'package:x_ten/core/storage/app_preferences.dart';

class LocaleInterceptor extends Interceptor {
  LocaleInterceptor(this._prefs);

  final AppPreferences _prefs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] =
        _prefs.languageCode ?? LocaleCubit.fallback.languageCode;
    handler.next(options);
  }
}
