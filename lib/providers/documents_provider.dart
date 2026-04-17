import 'package:flutter/foundation.dart';
import '../models/document.dart';
import '../models/filter_state.dart';
import '../models/tag.dart';
import '../models/correspondent.dart';
import '../models/document_type.dart';
import '../models/custom_field.dart';
import '../models/saved_view.dart';
import '../models/storage_path.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DocumentsProvider extends ChangeNotifier {
  final ApiService _api;

  List<Document> _documents = [];
  int _totalCount = 0;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;

  FilterState _filter = const FilterState();

  List<Tag> _tags = [];
  List<Correspondent> _correspondents = [];
  List<DocumentType> _documentTypes = [];
  List<CustomField> _customFields = [];
  List<SavedView> _savedViews = [];
  List<StoragePath> _storagePaths = [];
  SavedView? _selectedView;
  bool _metaLoaded = false;

  DocumentsProvider(this._api);

  List<Document> get documents => _documents;
  int get totalCount => _totalCount;
  bool get hasMore => _hasMore;
  bool get isLoading => _loading;
  bool get isLoadingMore => _loadingMore;
  String? get error => _error;
  FilterState get filter => _filter;
  List<Tag> get tags => _tags;
  List<Correspondent> get correspondents => _correspondents;
  List<DocumentType> get documentTypes => _documentTypes;
  List<CustomField> get customFields => _customFields;
  List<SavedView> get savedViews => _savedViews;
  List<StoragePath> get storagePaths => _storagePaths;
  SavedView? get selectedView => _selectedView;

  Future<void> init() async {
    await loadMeta();
    await _applyDefaultView();
    await loadDocuments();
  }

  Future<void> _applyDefaultView() async {
    final id = await StorageService().getDefaultViewId();
    if (id != null) {
      final view = _savedViews.where((v) => v.id == id).firstOrNull;
      if (view != null) _selectedView = view;
    }
  }

  Future<void> loadMeta() async {
    if (_metaLoaded) return;
    try {
      final results = await Future.wait([
        _api.getTags(),
        _api.getCorrespondents(),
        _api.getDocumentTypes(),
        _api.getCustomFields(),
        _api.getSavedViews(),
        _api.getStoragePaths(),
      ]);
      _tags = results[0] as List<Tag>;
      _correspondents = results[1] as List<Correspondent>;
      _documentTypes = results[2] as List<DocumentType>;
      _customFields = results[3] as List<CustomField>;
      _savedViews = results[4] as List<SavedView>;
      _storagePaths = results[5] as List<StoragePath>;
      _metaLoaded = true;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadDocuments() async {
    _loading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    try {
      final page = await _api.getDocuments(
        filter: _filter,
        savedView: _selectedView,
        page: 1,
      );
      _documents = page.results;
      _totalCount = page.count;
      _hasMore = page.next != null;
      _currentPage = 1;
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    _loadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final page = await _api.getDocuments(
        filter: _filter,
        savedView: _selectedView,
        page: nextPage,
      );
      _documents.addAll(page.results);
      _hasMore = page.next != null;
      _currentPage = nextPage;
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  void selectView(SavedView? view) {
    _selectedView = view;
    _filter = const FilterState();
    loadDocuments();
  }

  void updateFilter(FilterState newFilter) {
    _filter = newFilter;
    loadDocuments();
  }

  void resetFilter() {
    _filter = const FilterState();
    _selectedView = null;
    loadDocuments();
  }

  bool get hasActiveFilters =>
      _filter.hasActiveFilters || _selectedView != null;

  Tag? tagById(int id) {
    try {
      return _tags.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Correspondent? correspondentById(int id) {
    try {
      return _correspondents.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  DocumentType? documentTypeById(int id) {
    try {
      return _documentTypes.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  StoragePath? storagePathById(int id) {
    try {
      return _storagePaths.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Document> updateDocument(int id, Map<String, dynamic> data) async {
    final doc = await _api.updateDocument(id, data);
    final idx = _documents.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      _documents[idx] = doc;
      notifyListeners();
    }
    return doc;
  }

  Future<void> deleteDocument(int id) async {
    await _api.deleteDocument(id);
    _documents.removeWhere((d) => d.id == id);
    _totalCount = (_totalCount - 1).clamp(0, _totalCount);
    notifyListeners();
  }
}
