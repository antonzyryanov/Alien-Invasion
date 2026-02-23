import 'package:flutter/material.dart';

import '../../../../app_design/app_text_styles.dart';
import '../../../widgets/outlined_text.dart';

class GameHudLayer extends StatelessWidget {
  const GameHudLayer({
    required this.hudTopInset,
    required this.hudEdgeInset,
    required this.livesLabel,
    required this.pointsLabel,
    required this.timeLabel,
    required this.lives,
    required this.points,
    required this.elapsed,
    super.key,
  });

  final double hudTopInset;
  final double hudEdgeInset;
  final String livesLabel;
  final String pointsLabel;
  final String timeLabel;
  final int lives;
  final int points;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: hudTopInset,
          left: hudEdgeInset,
          child: OutlinedText(
            '$livesLabel: $lives',
            style: AppTextStyles.hud(context),
          ),
        ),
        Positioned(
          top: hudTopInset,
          right: hudEdgeInset,
          child: OutlinedText(
            '$pointsLabel: $points',
            style: AppTextStyles.hud(context),
          ),
        ),
        Positioned(
          bottom: hudTopInset,
          right: hudEdgeInset,
          child: OutlinedText(
            '$timeLabel: ${_format(elapsed)}',
            style: AppTextStyles.hud(context),
          ),
        ),
      ],
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
