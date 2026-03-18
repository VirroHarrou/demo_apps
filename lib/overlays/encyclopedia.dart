import 'package:demo_apps/domain/animal_info.dart';
import 'package:demo_apps/zoo_game.dart';
import 'package:flutter/material.dart';

class EncyclopediaOverlay extends StatelessWidget {
  final HungryZooGame game;
  const EncyclopediaOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => game.overlays.remove('Encyclopedia'),
            ),
            title: const Text(
              "Энциклопедия",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: zooEncyclopedia.length,
              separatorBuilder: (_, __) => const Divider(height: 30),
              itemBuilder: (context, index) {
                final animal = zooEncyclopedia[index];
                return Row(
                  children: [
                    Image.asset(
                      'assets/images/${animal.fileName}',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animal.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(animal.description),
                          Text(
                            animal.likes,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
