import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  final StorageService _storage;
  Locale? _locale;

  LocaleProvider(this._storage);

  Locale? get locale => _locale;

  Future<void> init() async {
    final tag = await _storage.getLocale();
    if (tag != null) {
      _locale = Locale(tag);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    await _storage.setLocale(locale?.languageCode);
    notifyListeners();
  }
}
