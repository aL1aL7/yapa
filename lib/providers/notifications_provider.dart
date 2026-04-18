import 'package:flutter/foundation.dart';
import '../models/task_notification.dart';
import '../services/api_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final ApiService _api;

  List<TaskNotification> _tasks = [];
  bool _loading = false;
  String? _error;

  NotificationsProvider(this._api);

  List<TaskNotification> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _loading;
  String? get error => _error;
  int get unacknowledgedCount => _tasks.where((t) => !t.acknowledged).length;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final tasks = await _api.getTasks();
      tasks.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      _tasks = tasks.where((t) => t.isFileTask && !t.acknowledged).toList();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Throws ApiException on failure — callers handle UX (e.g. SnackBar)
  Future<void> acknowledgeTask(int id) async {
    await _api.acknowledgeTasks([id]);
    // Refresh from server so the acknowledged task disappears from the list.
    await load();
  }

  // Throws ApiException on failure — callers handle UX (e.g. SnackBar)
  Future<void> acknowledgeAll() async {
    final ids = _tasks.where((t) => !t.acknowledged).map((t) => t.id).toList();
    if (ids.isEmpty) return;
    await _api.acknowledgeTasks(ids);
    // Refresh from server so all acknowledged tasks disappear from the list.
    await load();
  }
}
