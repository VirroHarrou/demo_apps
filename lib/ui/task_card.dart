import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onComplete;
  final bool isHistory;

  const TaskCard({
    required this.task,
    this.onComplete,
    this.isHistory = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isFailed =
        task.isFailed ||
        (DateTime.now().isAfter(task.deadline) && !task.isCompleted);

    Color? cardColor;
    if (task.isCompleted) {
      cardColor = Colors.green[50];
    } else if (isFailed) {
      cardColor = Colors.red[50];
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: isHistory ? 0 : 2,
      color: cardColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isHistory ? Colors.black12 : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: isHistory
            ? Icon(
                task.isCompleted ? Icons.check_circle : Icons.cancel,
                color: task.isCompleted ? Colors.green : Colors.red,
              )
            : Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onComplete?.call(),
              ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          "Дедлайн: ${DateFormat('dd.MM HH:mm').format(task.deadline)}",
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
