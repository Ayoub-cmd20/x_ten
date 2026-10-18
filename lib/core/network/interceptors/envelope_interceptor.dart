import 'package:dio/dio.dart';

class EnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic> && body['success'] == true && body.containsKey('data')) {
      response.data = body['data'];
    }
    handler.next(response);
  }
}
