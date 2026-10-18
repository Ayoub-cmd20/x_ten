import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class TokenStorage {
  String? get cachedAccess;
  Future<String?> readAccess();
  Future<String?> readRefresh();
  Future<bool> hasSession();
  Future<void> saveTokens({required String access, required String refresh});
  Future<void> saveAccess(String access);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final FlutterSecureStorage _storage;
  String? _access;

  Future<void> init() async {
    _access = await _storage.read(key: _accessKey);
  }

  @override
  String? get cachedAccess => _access;

  @override
  Future<String?> readAccess() async => _access ??= await _storage.read(key: _accessKey);

  @override
  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  @override
  Future<bool> hasSession() async => await readRefresh() != null;

  @override
  Future<void> saveTokens({required String access, required String refresh}) async {
    _access = access;
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  @override
  Future<void> saveAccess(String access) async {
    _access = access;
    await _storage.write(key: _accessKey, value: access);
  }

  @override
  Future<void> clear() async {
    _access = null;
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}
