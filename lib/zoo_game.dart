import 'dart:math';

import 'package:demo_apps/domain/components.dart';
import 'package:demo_apps/ui_elements.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class HungryZooGame extends FlameGame with DragCallbacks {
  HungryZooGame();

  Vector2? dragStart;
  Vector2? dragCurrent;

  bool isLastGameWin = false;

  AnimalComponent? activeAnimal;

  int currentRound = 1;
  final int maxRounds = 3;
  int fedInRound = 0;

  final Map<AnimalType, FoodType> diet = {
    AnimalType.cow: FoodType.milet,
    AnimalType.crow: FoodType.seed,
    AnimalType.bear: FoodType.fish,
    AnimalType.tiger: FoodType.meat,
    AnimalType.panda: FoodType.bambo,
    AnimalType.monkey: FoodType.banana,
  };

  @override
  Future<void> onLoad() async {
    await startNewRound();
  }

  @override
  backgroundColor() => Colors.white;

  void startPlaying() {
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    startNewRound();
  }

  void openEncyclopedia() {
    overlays.add('Encyclopedia');
  }

  Future<void> startNewRound() async {
    children.whereType<AnimalComponent>().forEach((a) => a.removeFromParent());
    children.whereType<FoodComponent>().forEach((f) => f.removeFromParent());
    children.whereType<NextRoundButton>().forEach((b) => b.removeFromParent());

    fedInRound = 0;
    final random = Random();

    List<AnimalType> roundAnimals = AnimalType.values.toList()..shuffle();
    roundAnimals = roundAnimals.take(4).toList();

    List<FoodComponent> roundFood = [];
    for (int i = 0; i < 3; i++) {
      roundFood.add(FoodComponent(diet[roundAnimals[i]]!, false));
    }
    add(HintTextComponent());

    for (int i = 0; i < 3; i++) {
      final type = FoodType.values[random.nextInt(FoodType.values.length)];
      final isSpoiled = random.nextBool();
      roundFood.add(FoodComponent(type, isSpoiled));
    }
    roundFood.shuffle();

    double foodSpacing = size.x / (roundFood.length + 1);
    for (int i = 0; i < roundFood.length; i++) {
      roundFood[i].position = Vector2(foodSpacing * (i + 1), 150);
      add(roundFood[i]);
    }

    double animalSpacing = size.x / (roundAnimals.length + 1);
    for (int i = 0; i < roundAnimals.length; i++) {
      add(
        AnimalComponent(
          roundAnimals[i],
          Vector2(animalSpacing * (i + 1), size.y - 150),
        ),
      );
    }
  }

  void checkRoundEnd() {
    if (fedInRound >= 1 && children.whereType<NextRoundButton>().isEmpty) {
      children.whereType<HintTextComponent>().forEach(
        (h) => h.removeFromParent(),
      );

      add(NextRoundButton(onPressed: nextStep));
    }
  }

  void nextStep() {
    if (currentRound >= maxRounds || fedInRound >= 4) {
      triggerGameOver(true);
    } else {
      currentRound++;
      startNewRound();
    }
  }

  void resetGame() {
    fedInRound = 0;
    children.whereType<AnimalComponent>().forEach((a) => a.satisfied = false);
    startNewRound();
    overlays.remove('GameOver');
    overlays.remove('MainMenu');
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final components = componentsAtPoint(event.canvasPosition);
    for (var c in components) {
      if (c is AnimalComponent && !c.satisfied) {
        activeAnimal = c;
        dragStart = event.canvasPosition.clone();
        dragCurrent = event.canvasPosition.clone();
      }
    }
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (activeAnimal != null) {
      final localPos = event.raw.localPosition.toVector2();
      dragCurrent = localPos;
      return true;
    }
    return false;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (activeAnimal != null && dragCurrent != null) {
      final components = componentsAtPoint(dragCurrent!);
      for (var c in components) {
        if (c is FoodComponent) {
          if (diet[activeAnimal!.type] == c.type && !c.isSpoiled) {
            activeAnimal!.satisfied = true;
            fedInRound++;
            c.removeFromParent();
            checkRoundEnd();
          } else {
            overlays.add('GameOver');
          }
          break;
        }
      }
    }
    activeAnimal = null;
    dragStart = null;
    dragCurrent = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (dragStart != null && dragCurrent != null) {
      canvas.drawLine(
        dragStart!.toOffset(),
        dragCurrent!.toOffset(),
        Paint()
          ..color = Colors.orangeAccent
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void triggerGameOver(bool isWin) {
    isLastGameWin = isWin;
    overlays.add('GameOver');
  }
}
