import 'package:flutter/material.dart';

class ShipWidget extends StatelessWidget {
  const ShipWidget({
    required this.shipCenter,
    required this.shipSize,
    required this.shipAsset,
    super.key,
  });

  final Offset shipCenter;
  final double shipSize;
  final String shipAsset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: shipCenter.dx - (shipSize / 2),
      top: shipCenter.dy - (shipSize / 2),
      width: shipSize,
      height: shipSize,
      child: Image.asset(
        shipAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const DecoratedBox(decoration: BoxDecoration(color: Colors.white)),
      ),
    );
  }
}
