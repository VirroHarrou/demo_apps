import 'dart:math';

import 'package:demo_apps/aviation_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlanePlayer extends SpriteComponent with HasGameReference<AviationGame> {
  double _shootTimer = 0;

  PlanePlayer() : super(size: Vector2(80, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('plane.png');
  }

  void resetShooting() => _shootTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    _shootTimer += dt;

    double currentShootInterval = game.difficulty.getShootInterval(game.score);

    if (_shootTimer > currentShootInterval) {
      game.add(Bullet(position: position.clone() - Vector2(0, size.y / 2)));
      _shootTimer = 0;
    }
  }
}

class Bullet extends SpriteComponent
    with HasGameReference<AviationGame>, CollisionCallbacks {
  Bullet({required Vector2 position})
    : super(position: position, size: Vector2(10, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('bullet.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    position.y -= 500 * dt; // Скорость пули вверх (фиксированная)
    if (position.y < -size.y) removeFromParent();
  }
}

class Balloon extends SpriteComponent
    with HasGameReference<AviationGame>, CollisionCallbacks {
  static final Random _rng = Random();
  double _currentSpeed = 0;

  Balloon() : super(size: Vector2(50, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('balloon.png');
    position = Vector2(_rng.nextDouble() * (game.size.x - 50) + 25, -50);
    _currentSpeed = game.difficulty.getBalloonSpeed(game.score);

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    position.y += _currentSpeed * dt;

    if (position.y > game.size.y + size.y / 2) {
      game.gameOver();
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      game.incrementScore();
      removeFromParent();
      other.removeFromParent();
    }
  }
}
