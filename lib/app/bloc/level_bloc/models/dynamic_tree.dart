import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DynamicTree extends Equatable {
  const DynamicTree({
    required this.center,
    required this.asset,
    required this.speed,
  });

  final Offset center;
  final String asset;
  final double speed;

  DynamicTree copyWith({Offset? center, String? asset, double? speed}) {
    return DynamicTree(
      center: center ?? this.center,
      asset: asset ?? this.asset,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [center, asset, speed];
}
