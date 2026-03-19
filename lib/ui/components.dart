import 'dart:math' as math;
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class CollisionCategory {
  static const int ball = 0x0001;
  static const int wall = 0x0002;
  static const int vortex = 0x0004;
}

class Vortex extends BodyComponent with ContactCallbacks {
  final Vector2 initialPosition;
  final Vector2 initialVelocity;
  final double radius = 45;

  Vortex({required this.initialPosition, required this.initialVelocity});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
      gravityOverride: Vector2.zero(),
      linearVelocity: initialVelocity,
      linearDamping: 0.0,
    );

    final body = world.createBody(bodyDef);
    final wallHitbox = CircleShape()..radius = radius;
    body.createFixture(FixtureDef(
      wallHitbox,
      restitution: 1.0,
      friction: 0.0,
      filter: Filter()
        ..categoryBits = CollisionCategory.vortex
        ..maskBits = CollisionCategory.wall,
    ));


    final sensorShape = CircleShape()..radius = radius * 0.5;
    body.createFixture(FixtureDef(
      sensorShape,
      isSensor: true,
      filter: Filter()
        ..categoryBits = CollisionCategory.vortex
        ..maskBits = CollisionCategory.ball,
    ));

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      other.shouldDestroy = true;
      other.onCollision();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.black, Colors.deepPurple, Colors.transparent],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, paint);
  }
}

class Ball extends BodyComponent with DragCallbacks, ContactCallbacks {
  final Vector2 initialPosition;
  final VoidCallback onCollision;
  final double radius = 32;

  Ball(this.initialPosition, {required this.onCollision});

  bool shouldDestroy = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (shouldDestroy) {
      removeFromParent();
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: initialPosition, type: BodyType.dynamic, userData: this);
    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;
    body.createFixture(FixtureDef(
      shape,
      restitution: 0.8,
      density: 1.0,
      filter: Filter()
        ..categoryBits = CollisionCategory.ball
        ..maskBits = CollisionCategory.wall | CollisionCategory.ball | CollisionCategory.vortex,
    ));
    return body;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    body.applyLinearImpulse(event.localDelta * 15000);
  }

  @override
  void render(Canvas canvas) {
    final path = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    canvas.clipPath(path);
    final paint = Paint()..isAntiAlias = true;
    canvas.drawCircle(Offset.zero, radius, paint..color = const Color(0xFFE76F51));
    final linePaint = Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawCircle(Offset.zero, radius, linePaint);
    canvas.drawLine(Offset(-radius, 0), Offset(radius, 0), linePaint);
    canvas.drawLine(Offset(0, -radius), Offset(0, radius), linePaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(-radius * 1.2, 0), radius: radius * 1.2), -math.pi / 2, math.pi, false, linePaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(radius * 1.2, 0), radius: radius * 1.2), math.pi / 2, math.pi, false, linePaint);
  }
}

class Wall extends BodyComponent {
  final Vector2 start; final Vector2 end;
  Wall(this.start, this.end);
  @override
  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape)
      ..filter.categoryBits = CollisionCategory.wall;

    return world.createBody(BodyDef(type: BodyType.static))
      ..createFixture(fixtureDef);
  }
}