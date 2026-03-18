import 'package:demo_apps/zoo_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class NextRoundButton extends PositionComponent
    with TapCallbacks, HasGameReference<HungryZooGame> {
  final VoidCallback onPressed;
  NextRoundButton({required this.onPressed}) : super(anchor: Anchor.center);

  @override
  void onMount() {
    position = Vector2(game.size.x / 2, game.size.y / 2);
    size = Vector2(150, 50);
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.x, size.y, const Radius.circular(10)),
      Paint()..color = Colors.green,
    );
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'ГОТОВО',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}

class HintTextComponent extends TextComponent
    with HasGameReference<HungryZooGame> {
  HintTextComponent()
    : super(
        text: 'Покажи животным дорогу к еде',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        anchor: Anchor.center,
      );

  @override
  void onMount() {
    position = Vector2(game.size.x / 2, game.size.y / 2);
    super.onMount();
  }
}
