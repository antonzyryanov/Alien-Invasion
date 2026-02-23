import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DynamicAmmunition extends Equatable {
  const DynamicAmmunition({
    required this.center,
    required this.speed,
    this.previousCenter,
  });

  final Offset center;
  final double speed;
  final Offset? previousCenter;

  DynamicAmmunition copyWith({
    Offset? center,
    double? speed,
    Offset? previousCenter,
  }) {
    return DynamicAmmunition(
      center: center ?? this.center,
      speed: speed ?? this.speed,
      previousCenter: previousCenter ?? this.previousCenter ?? this.center,
    );
  }

  @override
  List<Object?> get props => [center, speed, previousCenter];
}
