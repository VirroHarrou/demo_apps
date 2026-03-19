import 'package:flutter/material.dart';

class TreeDisplay extends StatelessWidget {
  final int hp;
  final VoidCallback onReset; // Добавляем колбэк для сброса

  const TreeDisplay({super.key, required this.hp, required this.onReset});

  String _getTreeAsset() {
    if (hp >= 75) return 'assets/images/tree0.png';
    if (hp >= 50) return 'assets/images/tree1.png';
    return 'assets/images/tree2.png';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 640,
            child: Image.asset(
              _getTreeAsset(),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text('Ошибка загрузки изображения дерева'),
                );
              },
            ),
          ),
        ),
        // Кнопка сброса в верхнем правом углу вкладки дерева
        Positioned(
          top: 10,
          right: 10,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Показываем подтверждение перед удалением
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Сброс прогресса"),
                  content: const Text(
                    "Вы уверены, что хотите удалить все задачи и восстановить дерево?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Отмена"),
                    ),
                    TextButton(
                      onPressed: () {
                        onReset();
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        "Да, сбросить",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Сброс"),
          ),
        ),
      ],
    );
  }
}
