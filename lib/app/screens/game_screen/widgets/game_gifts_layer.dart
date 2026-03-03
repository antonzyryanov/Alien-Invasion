import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_gift.dart';
import 'package:flutter/material.dart';

class GameGiftsLayer extends StatelessWidget {
  const GameGiftsLayer({required this.gifts, super.key});

  final List<DynamicGift> gifts;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final gift in gifts)
          Positioned(
            left: gift.center.dx - 32,
            top: gift.center.dy - 32,
            width: 64,
            height: 64,
            child: Image.asset(
              gift.asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.amber),
              ),
            ),
          ),
      ],
    );
  }
}
