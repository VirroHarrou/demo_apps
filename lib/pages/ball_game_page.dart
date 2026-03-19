import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/physics_ball_game.dart';

class BallGamePage extends StatefulWidget {
  const BallGamePage({super.key});

  @override
  State<BallGamePage> createState() => _BallGamePageState();
}

class _BallGamePageState extends State<BallGamePage> {
  late PhysicsBallGame _game;

  @override
  void initState() {
    super.initState();
    _game = PhysicsBallGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildScoreBoard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return ValueListenableBuilder<int>(
      valueListenable: _game.scoreNotifier,
      builder: (context, score, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Text(
            'Мячей попало в вронку: $score',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}