import 'package:demo_apps/zoo_game.dart';
import 'package:flutter/material.dart';

class MainMenuOverlay extends StatelessWidget {
  final HungryZooGame game;
  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[500],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "СЫТЫЙ ЗООПАРК",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 60),
              ),
              onPressed: game.startPlaying,
              child: const Text(
                "ИГРАТЬ",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: game.openEncyclopedia,
              child: const Text(
                "ЭНЦИКЛОПЕДИЯ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
