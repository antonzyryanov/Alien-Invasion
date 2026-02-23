import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_house.dart';
import 'package:flutter/material.dart';

class GameCityLayer extends StatelessWidget {
  const GameCityLayer({
    required this.houses,
    required this.viewport,
    required this.screenWidth,
    super.key,
  });

  final List<DynamicHouse> houses;
  final Size viewport;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final house in houses)
          Positioned(
            left: house.center.dx,
            top: house.center.dy,
            width: 120,
            height: 96,
            child: Image.asset(
              house.asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.brown),
              ),
            ),
          ),
      ],
    );
  }
}
