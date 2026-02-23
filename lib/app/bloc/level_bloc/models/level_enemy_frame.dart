import 'package:flutter/material.dart';

class LevelEnemyFrame {
  const LevelEnemyFrame({
    required this.enemyDirection,
    required this.enemyRects,
  });

  final double enemyDirection;
  final List<Rect> enemyRects;
}
