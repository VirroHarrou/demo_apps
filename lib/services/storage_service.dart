import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks_v2';
  static const String _hpKey = 'hp_v1';

  Future<void> saveData(int hp, List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, encoded);
    await prefs.setInt(_hpKey, hp);
  }

  Future<Map<String, dynamic>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksRaw = prefs.getString(_tasksKey);
    final int hp = prefs.getInt(_hpKey) ?? 100;

    List<Task> tasks = [];
    if (tasksRaw != null) {
      tasks = (jsonDecode(tasksRaw) as List)
          .map((i) => Task.fromJson(i))
          .toList();
    }
    return {'hp': hp, 'tasks': tasks};
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
    await prefs.setInt(_hpKey, 100);
  }
}
