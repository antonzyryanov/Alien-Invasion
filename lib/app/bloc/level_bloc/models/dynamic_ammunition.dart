import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DynamicAmmunition extends Equatable {
  const DynamicAmmunition({required this.center, required this.speed});

  final Offset center;
  final double speed;

  DynamicAmmunition copyWith({Offset? center, double? speed}) {
    return DynamicAmmunition(
      center: center ?? this.center,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [center, speed];
}
