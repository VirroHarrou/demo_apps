import 'package:demo_apps/aviation_game.dart';
import 'package:flutter/material.dart';

class MainMenuOverlay extends StatelessWidget {
  final AviationGame game;
  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AVIATION 2D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap & drag to fly. Shoot the balloons!',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: game.startGame,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'START GAME',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
