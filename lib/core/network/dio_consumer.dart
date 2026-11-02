import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:x_ten/core/errors/error_mapper.dart';
import 'package:x_ten/core/network/api_consumer.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer(this._dio);

  final Dio _dio;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query, bool auth = true}) =>
      _call(() => _dio.get<dynamic>(path, queryParameters: query, options: _opts(auth)));

  @override
  Future<dynamic> post(String path, {Object? data, bool auth = true}) =>
      _call(() => _dio.post<dynamic>(path, data: data, options: _opts(auth)));

  @override
  Future<dynamic> patch(String path, {Object? data}) =>
      _call(() => _dio.patch<dynamic>(path, data: data));

  @override
  Future<dynamic> put(String path, {Object? data}) =>
      _call(() => _dio.put<dynamic>(path, data: data));

  @override
  Future<dynamic> delete(String path) => _call(() => _dio.delete<dynamic>(path));

  @override
  Future<Uint8List> download(String url) async {
    final bytes = await _call(
      () => _dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes)),
    );
    return Uint8List.fromList(bytes as List<int>);
  }

  Options _opts(bool auth) => Options(extra: {'auth': auth});

  Future<dynamic> _call(Future<Response<dynamic>> Function() request) async {
    try {
      return (await request()).data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
