import 'package:demo_apps/zoo_game.dart';
import 'package:flame/components.dart';

enum FoodType { meat, banana, fish, seed, milet, bambo }

enum AnimalType { cow, crow, bear, tiger, panda, monkey }

class AnimalComponent extends SpriteComponent
    with HasGameReference<HungryZooGame> {
  final AnimalType type;
  bool satisfied = false;
  AnimalComponent(this.type, Vector2 pos)
    : super(position: pos, size: Vector2.all(80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async =>
      sprite = await game.loadSprite('${type.name}.png');

  @override
  void update(double dt) {
    super.update(dt);
    opacity = satisfied ? 0.3 : 1.0;
  }
}

class FoodComponent extends SpriteComponent
    with HasGameReference<HungryZooGame> {
  final FoodType type;
  final bool isSpoiled;
  FoodComponent(this.type, this.isSpoiled, [Vector2? pos])
    : super(
        position: pos ?? Vector2.zero(),
        size: Vector2.all(60),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(
      isSpoiled ? '${type.name}_spoiled.png' : '${type.name}.png',
    );
  }
}
