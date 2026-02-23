import 'package:flutter/material.dart';

import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_enemy.dart';

class GameEnemiesLayer extends StatelessWidget {
  const GameEnemiesLayer({
    required this.enemyTexture,
    required this.borderThickness,
    required this.enemySize,
    required this.dynamicEnemies,
    super.key,
  });

  final String enemyTexture;
  final double borderThickness;
  final double enemySize;
  final List<DynamicEnemy> dynamicEnemies;

  @override
  Widget build(BuildContext context) {
    final minX = enemySize / 2;
    final maxX = MediaQuery.of(context).size.width - enemySize / 2;

    return Stack(
      children: [
        ...dynamicEnemies.map((enemy) {
          final clampedX = enemy.center.dx.clamp(minX, maxX);
          return Positioned(
            left: clampedX - (enemySize / 2),
            top: enemy.center.dy - (enemySize / 2),
            width: enemySize,
            height: enemySize,
            child: _EnemySprite(assetPath: enemyTexture),
          );
        }),
      ],
    );
  }
}

class _EnemySprite extends StatelessWidget {
  const _EnemySprite({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const DecoratedBox(
        decoration: BoxDecoration(color: Colors.redAccent),
      ),
    );
  }
}
