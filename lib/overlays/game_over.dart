import 'package:flutter/material.dart';
import '../zoo_game.dart';

class GameOverOverlay extends StatelessWidget {
  final HungryZooGame game;
  final bool isWin;

  const GameOverOverlay({super.key, required this.game, required this.isWin});

  @override
  Widget build(BuildContext context) {
    // Настройка контента в зависимости от результата
    final String title = isWin ? "ПОБЕДА!" : "ИГРА ОКОНЧЕНА";
    final String message = isWin
        ? "Вы накормили всех животных свежей едой!"
        : "Ой! Животное расстроилось из-за плохой еды.";
    final IconData icon = isWin
        ? Icons.emoji_emotions
        : Icons.sentiment_very_dissatisfied;
    final Color color = isWin ? Colors.green : Colors.redAccent;

    return Container(
      color: Colors.blueGrey[500],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 42,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  game.overlays.remove('GameOver');
                  game.resetGame();
                },
                child: const Text(
                  "РЕСТАРТ",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                game.overlays.remove('GameOver');
                game.overlays.add('MainMenu');
              },
              child: const Text(
                "В МЕНЮ",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
