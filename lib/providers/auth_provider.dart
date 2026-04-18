import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final StorageService _storage;

  AuthStatus _status = AuthStatus.unknown;
  ApiService? _api;
  String? _serverUrl;
  String? _username;
  String? _error;
  bool _loading = false;

  AuthProvider(this._storage);

  AuthStatus get status => _status;
  ApiService? get api => _api;
  String? get serverUrl => _serverUrl;
  String? get username => _username;
  String? get error => _error;
  bool get isLoading => _loading;

  Future<void> init() async {
    final creds = await _storage.getCredentials();
    final token = await _storage.getToken();
    final allowSelfSigned = await _storage.getAllowSelfSigned();
    final pinnedFingerprint = await _storage.getCertFingerprint();

    if (token != null && creds.serverUrl != null) {
      _serverUrl = creds.serverUrl;
      _username = creds.username;
      _api = ApiService(
        baseUrl: _serverUrl!,
        token: token,
        allowSelfSigned: allowSelfSigned,
        pinnedCertSha256: pinnedFingerprint,
      );
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({
    required String serverUrl,
    required String username,
    required String password,
    bool allowSelfSigned = false,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.authenticate(
        baseUrl: serverUrl,
        username: username,
        password: password,
        allowSelfSigned: allowSelfSigned,
      );

      // TOFU: the first time we see a self-signed cert, pin its SHA-256 so
      // later sessions reject anything else.
      final fingerprint = result.certSha256;
      if (allowSelfSigned && fingerprint != null) {
        await _storage.setCertFingerprint(fingerprint);
      }

      await _storage.saveToken(result.token);
      await _storage.saveCredentials(serverUrl: serverUrl, username: username);
      await _storage.setAllowSelfSigned(allowSelfSigned);

      _serverUrl = serverUrl;
      _username = username;
      _api = ApiService(
        baseUrl: serverUrl,
        token: result.token,
        allowSelfSigned: allowSelfSigned,
        pinnedCertSha256: fingerprint,
      );
      _status = AuthStatus.authenticated;
      _loading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _loading = false;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithToken({
    required String serverUrl,
    required String token,
    bool allowSelfSigned = false,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate the token by creating the service and making a lightweight request.
      // No pin yet — first call runs in TOFU mode and captures the cert fingerprint.
      final api = ApiService(
        baseUrl: serverUrl,
        token: token,
        allowSelfSigned: allowSelfSigned,
      );
      await api.getTags(); // will throw ApiException if token/URL is invalid

      // TOFU: pin the cert we just accepted.
      final fingerprint = api.lastSeenCertSha256;
      if (allowSelfSigned && fingerprint != null) {
        await _storage.setCertFingerprint(fingerprint);
      }

      await _storage.saveToken(token);
      await _storage.saveCredentials(serverUrl: serverUrl, username: null);
      await _storage.setAllowSelfSigned(allowSelfSigned);

      _serverUrl = serverUrl;
      _username = null;
      _api = api;
      _status = AuthStatus.authenticated;
      _loading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _loading = false;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
    _api = null;
    _serverUrl = null;
    _username = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
