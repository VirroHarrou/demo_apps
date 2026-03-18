import 'package:demo_apps/aviation_game.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final AviationGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[900]!.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Score: ${game.score}',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: game.startGame,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: Text(
                  'PLAY AGAIN',
                  style: TextStyle(fontSize: 22, color: Colors.red[900]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
