import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FloatingBonusFeedback extends Equatable {
  const FloatingBonusFeedback({
    required this.center,
    required this.points,
    required this.totalSeconds,
    required this.remainingSeconds,
  });

  final Offset center;
  final int points;
  final double totalSeconds;
  final double remainingSeconds;

  FloatingBonusFeedback copyWith({
    Offset? center,
    int? points,
    double? totalSeconds,
    double? remainingSeconds,
  }) {
    return FloatingBonusFeedback(
      center: center ?? this.center,
      points: points ?? this.points,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  bool get isAlive => remainingSeconds > 0;

  double get opacity {
    final ratio = remainingSeconds / totalSeconds;
    if (ratio <= 0) return 0;
    if (ratio > 1) return 1;
    if (ratio >= 0.45) return 1;
    return ratio / 0.45;
  }

  @override
  List<Object?> get props => [center, points, totalSeconds, remainingSeconds];
}
