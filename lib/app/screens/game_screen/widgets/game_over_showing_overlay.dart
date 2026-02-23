import 'package:flutter/material.dart';

import '../../../widgets/outlined_text.dart';

class GameOverShowingOverlay extends StatelessWidget {
  const GameOverShowingOverlay({
    required this.gameOverSize,
    required this.gameOverText,
    required this.gameOverTextStyle,
    super.key,
  });

  final Size gameOverSize;
  final String gameOverText;
  final TextStyle gameOverTextStyle;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: SizedBox(
          height: gameOverSize.height,
          width: gameOverSize.width,
          child: Image.asset(
            'assets/images/game_over/game_over.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) =>
                OutlinedText(gameOverText, style: gameOverTextStyle),
          ),
        ),
      ),
    );
  }
}
