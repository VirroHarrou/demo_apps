import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../ui/components.dart';

class PhysicsBallGame extends Forge2DGame with DragCallbacks, TapCallbacks, ContactCallbacks {
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  PhysicsBallGame() : super(gravity: Vector2(0, 30));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 1.0;
    camera.viewfinder.anchor = Anchor.topLeft;

    final visibleRect = camera.visibleWorldRect;
    addAll(createBoundaries(visibleRect));

    final random = math.Random();
    final randomVelocity = Vector2(
        random.nextBool()
            ? -100 + random.nextDouble() * 30
            : 90 + random.nextDouble() * 30,
        random.nextBool()
            ? -100 + random.nextDouble() * 30
            : 90 + random.nextDouble() * 30,
    );

    add(Vortex(
      initialPosition: Vector2(visibleRect.width / 2, visibleRect.height * 0.8),
      initialVelocity: randomVelocity,
    ));

    _spawnBall(visibleRect.center.toVector2());
  }

  void _spawnBall(Vector2 position) {
    add(Ball(
      position,
      onCollision: () => scoreNotifier.value++,
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    final components = componentsAtPoint(event.localPosition);
    final isNotEmptyUnderTap = components.any((c) => c is Ball || c is Vortex);

    if (!isNotEmptyUnderTap) {
      _spawnBall(event.localPosition);
    }
  }

  List<Wall> createBoundaries(Rect visibleRect) {
    final topLeft = visibleRect.topLeft.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final topRight = Vector2(bottomRight.x, topLeft.y);
    final bottomLeft = Vector2(topLeft.x, bottomRight.y);

    return [
      Wall(topLeft, topRight), Wall(topRight, bottomRight),
      Wall(bottomRight, bottomLeft), Wall(bottomLeft, topLeft),
    ];
  }
}