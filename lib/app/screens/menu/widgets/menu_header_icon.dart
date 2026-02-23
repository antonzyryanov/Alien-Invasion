import 'package:flutter/material.dart';

class MenuHeaderIcon extends StatelessWidget {
  const MenuHeaderIcon({required this.iconSize, super.key});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: Image.asset(
        'assets/images/enemies/enemy_5.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
