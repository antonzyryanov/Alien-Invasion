import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DynamicCloud extends Equatable {
  const DynamicCloud({
    required this.center,
    required this.asset,
    required this.speed,
  });

  final Offset center;
  final String asset;
  final double speed;

  DynamicCloud copyWith({Offset? center, String? asset, double? speed}) {
    return DynamicCloud(
      center: center ?? this.center,
      asset: asset ?? this.asset,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [center, asset, speed];
}
