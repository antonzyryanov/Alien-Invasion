import 'package:flutter/material.dart';

class LevelShipFrame {
  const LevelShipFrame({
    required this.shipCenter,
    required this.shipVelocity,
    required this.hitEnemy,
  });

  final Offset shipCenter;
  final Offset shipVelocity;
  final bool hitEnemy;
}
