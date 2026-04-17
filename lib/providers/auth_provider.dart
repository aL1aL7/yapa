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

    if (token != null && creds.serverUrl != null) {
      _serverUrl = creds.serverUrl;
      _username = creds.username;
      _api = ApiService(
        baseUrl: _serverUrl!,
        token: token,
        allowSelfSigned: allowSelfSigned,
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
      final token = await ApiService.authenticate(
        baseUrl: serverUrl,
        username: username,
        password: password,
        allowSelfSigned: allowSelfSigned,
      );

      await _storage.saveToken(token);
      await _storage.saveCredentials(serverUrl: serverUrl, username: username);
      await _storage.setAllowSelfSigned(allowSelfSigned);

      _serverUrl = serverUrl;
      _username = username;
      _api = ApiService(baseUrl: serverUrl, token: token, allowSelfSigned: allowSelfSigned);
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
