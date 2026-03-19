import 'package:demo_apps/services/storage_service.dart';
import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../ui/task_card.dart';
import '../ui/tree_display.dart';
import '../ui/add_task_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GameService _gameService = GameService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _gameService.onUpdate = () {
      if (mounted) setState(() {});
    };
    _initData();
  }

  Future<void> _initData() async {
    await _gameService.loadData();
    setState(() => _isLoading = false);
  }

  void _handleAddTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (newTask) async {
          await _gameService.addTask(newTask);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Дерево задач",
            style: TextStyle(
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.lightGreen[200],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.checklist), text: "Задачи"),
              Tab(icon: Icon(Icons.local_florist), text: "Древо"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(),
            TreeDisplay(
              hp: _gameService.hp,
              onReset: () async {
                final storage = StorageService();
                await storage.clearData();
                setState(() {
                  _gameService.tasks.clear();
                  _gameService.hp = 100;
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleAddTask,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final activeTasks = _gameService.tasks.where((t) {
      final isExpired = DateTime.now().isAfter(t.deadline);
      return !t.isCompleted && !t.isFailed && !isExpired;
    }).toList();
    final historyTasks = _gameService.tasks.where((t) {
      final isExpired = DateTime.now().isAfter(t.deadline);
      return t.isCompleted || t.isFailed || isExpired;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (historyTasks.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Завершенные задачи",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              children: historyTasks
                  .map((task) => TaskCard(task: task, isHistory: true))
                  .toList(),
            ),
          ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(),
        ),

        if (activeTasks.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Нет активных задач"),
            ),
          )
        else
          ...activeTasks.map(
            (task) => TaskCard(
              task: task,
              onComplete: () async {
                await _gameService.completeTask(task);
                setState(() {});
              },
            ),
          ),
      ],
    );
  }
}
