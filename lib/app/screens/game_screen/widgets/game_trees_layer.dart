import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_tree.dart';
import 'package:flutter/material.dart';

class GameTreesLayer extends StatelessWidget {
  const GameTreesLayer({
    required this.trees,
    required this.viewport,
    required this.screenWidth,
    super.key,
  });

  final List<DynamicTree> trees;
  final Size viewport;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final tree in trees)
          Positioned(
            left: tree.center.dx,
            top: tree.center.dy,
            width: 120,
            height: 144,
            child: Image.asset(
              tree.asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.green),
              ),
            ),
          ),
      ],
    );
  }
}
