import 'dart:async';
import '../models/task.dart';
import 'storage_service.dart';

class GameService {
  final StorageService _storage = StorageService();
  List<Task> tasks = [];
  int hp = 100;
  Timer? _deadlineTimer;
  Function? onUpdate;

  Future<void> loadData() async {
    final data = await _storage.loadData();
    tasks = data['tasks'];
    _updateState();
    _startDeadlineCheck();
  }

  void _updateState() {
    hp = _calculateHP();
    _storage.saveData(hp, tasks);
    onUpdate?.call();
  }

  int _calculateHP() {
    final finishedTasks = tasks
        .where((t) => t.isCompleted || t.isFailed)
        .toList();
    if (finishedTasks.isEmpty) return 100;

    final completedCount = finishedTasks.where((t) => t.isCompleted).length;
    return ((completedCount / finishedTasks.length) * 100).round();
  }

  void _startDeadlineCheck() {
    _deadlineTimer?.cancel();
    _deadlineTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      bool changed = false;
      final now = DateTime.now();

      for (var task in tasks) {
        if (task.isCompleted) continue;
        if (!task.isCompleted && !task.isFailed && now.isAfter(task.deadline)) {
          task.isFailed = true;
          changed = true;
        }
      }

      if (changed) {
        _updateState();
      }
    });
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await _storage.saveData(hp, tasks);
    onUpdate?.call();
  }

  Future<void> completeTask(Task task) async {
    final index = tasks.indexOf(task);
    if (index != -1 && !tasks[index].isCompleted && !tasks[index].isFailed) {
      tasks[index].isCompleted = true;
      _updateState();
    }
  }

  void dispose() => _deadlineTimer?.cancel();
}
