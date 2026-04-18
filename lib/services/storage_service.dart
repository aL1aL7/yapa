import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _keyToken = 'auth_token';
  static const _keyServerUrl = 'server_url';
  static const _keyUsername = 'username';
  static const _keyAllowSelfSigned = 'allow_self_signed';
  static const _keyDefaultViewId = 'default_view_id';
  static const _keyLocale = 'locale';

  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> deleteToken() => _storage.delete(key: _keyToken);

  Future<void> saveCredentials({
    required String serverUrl,
    required String username,
  }) async {
    await _storage.write(key: _keyServerUrl, value: serverUrl);
    await _storage.write(key: _keyUsername, value: username);
  }

  Future<({String? serverUrl, String? username})> getCredentials() async {
    final serverUrl = await _storage.read(key: _keyServerUrl);
    final username = await _storage.read(key: _keyUsername);
    return (serverUrl: serverUrl, username: username);
  }

  Future<void> clearAll() => _storage.deleteAll();

  Future<bool> getAllowSelfSigned() async =>
      (await _storage.read(key: _keyAllowSelfSigned)) == 'true';

  Future<void> setAllowSelfSigned(bool value) =>
      _storage.write(key: _keyAllowSelfSigned, value: value.toString());

  Future<int?> getDefaultViewId() async {
    final raw = await _storage.read(key: _keyDefaultViewId);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> setDefaultViewId(int? id) async {
    if (id == null) {
      await _storage.delete(key: _keyDefaultViewId);
    } else {
      await _storage.write(key: _keyDefaultViewId, value: id.toString());
    }
  }

  Future<String?> getLocale() => _storage.read(key: _keyLocale);

  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) {
      await _storage.delete(key: _keyLocale);
    } else {
      await _storage.write(key: _keyLocale, value: languageCode);
    }
  }
}
