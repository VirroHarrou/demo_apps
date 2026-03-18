import 'package:demo_apps/entities.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'difficulty_manager.dart';
import 'overlays/overlays.dart';

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<AviationGame>(
          game: AviationGame(),
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenuOverlay(game: game),
            'GameOver': (context, game) => GameOverOverlay(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}

enum GameState { menu, playing, gameOver }

class AviationGame extends FlameGame with HasCollisionDetection, PanDetector {
  late PlanePlayer player;
  int score = 0;
  double _spawnTimer = 0;
  GameState state = GameState.menu;
  final DifficultyManager difficulty = DifficultyManager();

  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    player = PlanePlayer();
    add(player);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);

    player.setOpacity(0);
  }

  void startGame() {
    score = 0;
    _spawnTimer = 0;
    state = GameState.playing;

    children.whereType<Balloon>().forEach((b) => b.removeFromParent());
    children.whereType<Bullet>().forEach((b) => b.removeFromParent());

    player.position = Vector2(size.x / 2, size.y - 100);
    player.setOpacity(1);
    scoreText.text = 'Score: 0';
    player.resetShooting();

    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    resumeEngine();
  }

  void incrementScore() {
    score++;
    scoreText.text = 'Score: $score';
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state != GameState.playing) return;

    _spawnTimer += dt;

    double currentSpawnInterval = difficulty.getSpawnInterval(score);

    if (_spawnTimer > currentSpawnInterval) {
      add(Balloon());
      _spawnTimer = 0;
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (state == GameState.playing) {
      final newPos = player.position + info.delta.global;
      player.position = Vector2(
        newPos.x.clamp(player.size.x / 2, size.x - player.size.x / 2),
        newPos.y.clamp(size.y / 2, size.y - player.size.y / 2),
      );
    }
  }

  void gameOver() {
    state = GameState.gameOver;
    pauseEngine();
    player.setOpacity(0);
    overlays.add('GameOver');
  }
}
