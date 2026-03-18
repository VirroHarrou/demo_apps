import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'zoo_game.dart';
import 'overlays/main_menu.dart';
import 'overlays/game_over.dart';
import 'overlays/encyclopedia.dart';

void main() {
  runApp(const MaterialApp(home: ZooApp()));
}

class ZooApp extends StatelessWidget {
  const ZooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<HungryZooGame>(
        game: HungryZooGame(),
        overlayBuilderMap: {
          'MainMenu': (context, game) => MainMenuOverlay(game: game),
          'GameOver': (context, game) =>
              GameOverOverlay(game: game, isWin: (game).isLastGameWin),
          'Encyclopedia': (context, game) => EncyclopediaOverlay(game: game),
        },
        initialActiveOverlays: const ['MainMenu'],
      ),
    );
  }
}
