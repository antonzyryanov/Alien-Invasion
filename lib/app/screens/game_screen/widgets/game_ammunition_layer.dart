import 'package:alien_invasion/app_design/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_ammunition.dart';

class GameAmmunitionLayer extends StatelessWidget {
  const GameAmmunitionLayer({
    required this.ammunition,
    required this.viewport,
    required this.ammunitionAsset,
    super.key,
  });

  final List<DynamicAmmunition> ammunition;
  final Size viewport;
  final String ammunitionAsset;

  @override
  Widget build(BuildContext context) {
    final ammoSize = AppDimensions.ammunitionSizeForSize(viewport);
    return Stack(
      children: [
        for (final ammo in ammunition)
          Positioned(
            left: ammo.center.dx - ammoSize / 2,
            top: ammo.center.dy - ammoSize / 2,
            width: ammoSize,
            height: ammoSize,
            child: Image.asset(
              ammunitionAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.yellow),
              ),
            ),
          ),
      ],
    );
  }
}
