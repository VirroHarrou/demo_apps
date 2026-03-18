import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

const List<Color> ballColors = [
  Color.fromARGB(255, 131, 231, 81),
  Color(0xFF4ECDC4),
  Color(0xFFE76F51),
  Colors.purple,
];

class BallGameScreen extends StatelessWidget {
  const BallGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: PhysicsBallGame()));
  }
}

class PhysicsBallGame extends Forge2DGame
    with DragCallbacks, TapCallbacks, ContactCallbacks {
  PhysicsBallGame() : super(gravity: Vector2(0, 30));

  int collisionCount = 0;
  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 1.0;
    camera.viewfinder.anchor = Anchor.topLeft;

    addAll(createBoundaries());

    scoreText = TextComponent(
      text: 'Collisions: $collisionCount',
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 32, color: Colors.white70),
      ),
    );
    add(scoreText);
  }

  void _spawnBall(Vector2 position) {
    add(
      Ball(
        position,
        onCollision: () {
          collisionCount++;
          scoreText.text = 'Collisions: ${(collisionCount / 2).toInt()}';
        },
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Получаем список всех компонентов в точке нажатия
    final components = componentsAtPoint(event.localPosition);

    // Ищем среди них хотя бы один Ball
    final isBallUnderPoint = components.any((c) => c is Ball);

    // Спавним новый мяч только если под пальцем пусто
    if (!isBallUnderPoint) {
      _spawnBall(event.localPosition);
    }
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final topRight = Vector2(bottomRight.x, topLeft.y);
    final bottomLeft = Vector2(topLeft.x, bottomRight.y);

    return [
      Wall(topLeft, topRight),
      Wall(topRight, bottomRight),
      Wall(bottomRight, bottomLeft),
      Wall(bottomLeft, topLeft),
    ];
  }
}

class Ball extends BodyComponent with DragCallbacks, ContactCallbacks {
  final Vector2 initialPosition;
  final VoidCallback onCollision;
  final double radius = 32;

  Ball(this.initialPosition, {required this.onCollision});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      onCollision();
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.7,
      friction: 0.4,
      density: 1,
    );

    body.createFixture(fixtureDef);
    return body;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    body.applyLinearImpulse(event.localDelta * 50000);
  }

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    canvas.clipPath(path);

    final basePaint = Paint()
      ..color = ballColors[body.hashCode % ballColors.length]
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset.zero, radius, basePaint);

    final linePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    canvas.drawCircle(Offset.zero, radius, linePaint);

    canvas.drawLine(Offset(-radius, 0), Offset(radius, 0), linePaint);
    canvas.drawLine(Offset(0, -radius), Offset(0, radius), linePaint);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(-radius * 1.2, 0), radius: radius * 1.2),
      -math.pi / 2,
      math.pi,
      false,
      linePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius * 1.2, 0), radius: radius * 1.2),
      math.pi / 2,
      math.pi,
      false,
      linePaint,
    );
  }
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final bodyDef = BodyDef(type: BodyType.static);
    final body = world.createBody(bodyDef);
    body.createFixture(FixtureDef(shape, friction: 0.3));
    return body;
  }
}
