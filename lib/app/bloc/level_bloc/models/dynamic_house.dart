import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DynamicHouse extends Equatable {
  const DynamicHouse({
    required this.center,
    required this.asset,
    required this.speed,
  });

  final Offset center;
  final String asset;
  final double speed;

  DynamicHouse copyWith({Offset? center, String? asset, double? speed}) {
    return DynamicHouse(
      center: center ?? this.center,
      asset: asset ?? this.asset,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [center, asset, speed];
}
