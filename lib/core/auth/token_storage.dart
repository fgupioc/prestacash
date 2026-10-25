import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Cache en memoria para no leer el storage en cada request
  String? _accessToken;
  String? _refreshToken;

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  Future<String?> get accessToken async =>
      _accessToken ??= await _storage.read(key: _kAccess);

  Future<String?> get refreshToken async =>
      _refreshToken ??= await _storage.read(key: _kRefresh);

  Future<bool> hasSession() async => (await refreshToken) != null;

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }
}