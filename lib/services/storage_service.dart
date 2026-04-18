import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // flutter_secure_storage 10.x already uses a secure, non-deprecated cipher
  // backend by default. The previous `encryptedSharedPreferences` option was
  // based on Google's deprecated Jetpack Security library and is itself
  // deprecated in v10 — data is transparently migrated to the new ciphers.
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _keyToken = 'auth_token';
  static const _keyServerUrl = 'server_url';
  static const _keyUsername = 'username';
  static const _keyAllowSelfSigned = 'allow_self_signed';
  static const _keyDefaultViewId = 'default_view_id';
  static const _keyLocale = 'locale';
  static const _keyTagsAsDropdown = 'tags_as_dropdown';
  static const _keySavedViewsAsDropdown = 'saved_views_as_dropdown';
  static const _keyCertFingerprint = 'cert_fingerprint';

  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> deleteToken() => _storage.delete(key: _keyToken);

  Future<void> saveCredentials({
    required String serverUrl,
    String? username,
  }) async {
    await _storage.write(key: _keyServerUrl, value: serverUrl);
    if (username != null) {
      await _storage.write(key: _keyUsername, value: username);
    } else {
      await _storage.delete(key: _keyUsername);
    }
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

  Future<bool> getTagsAsDropdown() async =>
      (await _storage.read(key: _keyTagsAsDropdown)) == 'true';

  Future<void> setTagsAsDropdown(bool value) =>
      _storage.write(key: _keyTagsAsDropdown, value: value.toString());

  Future<bool> getSavedViewsAsDropdown() async =>
      (await _storage.read(key: _keySavedViewsAsDropdown)) == 'true';

  Future<void> setSavedViewsAsDropdown(bool value) =>
      _storage.write(key: _keySavedViewsAsDropdown, value: value.toString());

  Future<String?> getCertFingerprint() =>
      _storage.read(key: _keyCertFingerprint);

  Future<void> setCertFingerprint(String? fingerprint) async {
    if (fingerprint == null) {
      await _storage.delete(key: _keyCertFingerprint);
    } else {
      await _storage.write(key: _keyCertFingerprint, value: fingerprint);
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
