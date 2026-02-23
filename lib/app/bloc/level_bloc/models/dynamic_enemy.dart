import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum EnemyPath { horizontal, vertical }

class DynamicEnemy extends Equatable {
  const DynamicEnemy({
    required this.center,
    required this.path,
    required this.direction,
  });

  final Offset center;
  final EnemyPath path;
  final double direction;

  DynamicEnemy copyWith({Offset? center, EnemyPath? path, double? direction}) {
    return DynamicEnemy(
      center: center ?? this.center,
      path: path ?? this.path,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [center, path, direction];
}
