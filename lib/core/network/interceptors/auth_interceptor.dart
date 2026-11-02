import 'package:dio/dio.dart';
import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/errors/api_error.dart';
import 'package:x_ten/core/session/session_notifier.dart';
import 'package:x_ten/core/storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio plainDio,
    required TokenStorage storage,
    required SessionNotifier session,
  })  : _plainDio = plainDio,
        _storage = storage,
        _session = session;

  final Dio _plainDio;
  final TokenStorage _storage;
  final SessionNotifier _session;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_requiresAuth(options)) {
      final access = await _storage.readAccess();
      if (access != null) options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (!_requiresAuth(options)) {
      handler.next(err);
      return;
    }

    final code = ApiError.fromResponse(err.response?.data).code;

    if (code == 'authentication_failed') {
      await _endSession(SessionEndReason.suspended);
      handler.next(err);
      return;
    }
    if (code != 'token_not_valid' || options.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    String? newAccess;
    try {
      newAccess = await _refreshIfNeeded(options);
    } on DioException {
      handler.next(err);
      return;
    }

    if (newAccess == null) {
      await _endSession(SessionEndReason.expired);
      handler.next(err);
      return;
    }

    options.headers['Authorization'] = 'Bearer $newAccess';
    options.extra['retried'] = true;
    final data = options.data;
    if (data is FormData) options.data = data.clone();

    try {
      handler.resolve(await _plainDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _requiresAuth(RequestOptions options) => options.extra['auth'] != false;

  Future<String?> _refreshIfNeeded(RequestOptions failed) async {
    final sent = (failed.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final current = await _storage.readAccess();
    if (current != null && current != sent) return current;

    final refresh = await _storage.readRefresh();
    if (refresh == null) return null;

    try {
      final response = await _plainDio.post<dynamic>(
        ApiEndpoints.refresh,
        data: {'refresh': refresh},
      );
      final access = (response.data as Map<String, dynamic>)['access'] as String;
      await _storage.saveAccess(access);
      return access;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return null;
    }
  }

  Future<void> _endSession(SessionEndReason reason) async {
    await _storage.clear();
    _session.end(reason);
  }
}
