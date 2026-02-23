import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_cloud.dart';
import 'package:flutter/material.dart';

class GameCloudsLayer extends StatelessWidget {
  const GameCloudsLayer({
    required this.clouds,
    required this.viewport,
    required this.screenWidth,
    super.key,
  });

  final List<DynamicCloud> clouds;
  final Size viewport;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final cloud in clouds)
          Positioned(
            left: cloud.center.dx,
            top: cloud.center.dy,
            width: 120,
            height: 72,
            child: Image.asset(
              cloud.asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.white70),
              ),
            ),
          ),
      ],
    );
  }
}
