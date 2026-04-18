import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppSettingsProvider extends ChangeNotifier {
  final StorageService _storage;

  bool _tagsAsDropdown = false;
  bool _savedViewsAsDropdown = false;

  AppSettingsProvider(this._storage);

  bool get tagsAsDropdown => _tagsAsDropdown;
  bool get savedViewsAsDropdown => _savedViewsAsDropdown;

  Future<void> init() async {
    _tagsAsDropdown = await _storage.getTagsAsDropdown();
    _savedViewsAsDropdown = await _storage.getSavedViewsAsDropdown();
    notifyListeners();
  }

  Future<void> setTagsAsDropdown(bool value) async {
    _tagsAsDropdown = value;
    await _storage.setTagsAsDropdown(value);
    notifyListeners();
  }

  Future<void> setSavedViewsAsDropdown(bool value) async {
    _savedViewsAsDropdown = value;
    await _storage.setSavedViewsAsDropdown(value);
    notifyListeners();
  }
}
