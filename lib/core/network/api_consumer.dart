import 'dart:typed_data';

abstract interface class ApiConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? query, bool auth = true});
  Future<dynamic> post(String path, {Object? data, bool auth = true});
  Future<dynamic> patch(String path, {Object? data});
  Future<dynamic> put(String path, {Object? data});
  Future<dynamic> delete(String path);
  Future<Uint8List> download(String url);
}
