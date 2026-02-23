import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';
import '../../../widgets/outlined_text.dart';

class LevelFinishedOverlay extends StatelessWidget {
  const LevelFinishedOverlay({
    required this.points,
    required this.scoreLabel,
    required this.backLabel,
    required this.scoreTextStyle,
    required this.bottomActionInset,
    required this.buttonHeight,
    required this.onBackToMenu,
    super.key,
  });

  final int points;
  final String scoreLabel;
  final String backLabel;
  final TextStyle scoreTextStyle;
  final double bottomActionInset;
  final double buttonHeight;
  final VoidCallback onBackToMenu;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.overlay,
        child: Stack(
          children: [
            Center(
              child: OutlinedText(
                '$scoreLabel: $points',
                style: scoreTextStyle,
              ),
            ),
            Positioned(
              left: bottomActionInset,
              right: bottomActionInset,
              bottom: bottomActionInset,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: onBackToMenu,
                  child: Text(backLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
