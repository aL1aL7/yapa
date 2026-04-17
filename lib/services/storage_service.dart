import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _keyToken = 'auth_token';
  static const _keyServerUrl = 'server_url';
  static const _keyUsername = 'username';
  static const _keyAllowSelfSigned = 'allow_self_signed';
  static const _keyDefaultViewId = 'default_view_id';

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

  Future<void> clearAll() async {
    await _storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> getAllowSelfSigned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAllowSelfSigned) ?? false;
  }

  Future<void> setAllowSelfSigned(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAllowSelfSigned, value);
  }

  Future<int?> getDefaultViewId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDefaultViewId);
  }

  Future<void> setDefaultViewId(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyDefaultViewId);
    } else {
      await prefs.setInt(_keyDefaultViewId, id);
    }
  }
}
