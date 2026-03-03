import 'package:flutter/material.dart';

import '../../../../app_design/app_text_styles.dart';
import '../../../bloc/level_bloc/models/floating_bonus_feedback.dart';
import '../../../widgets/outlined_text.dart';

class GameGiftBonusFeedbackLayer extends StatelessWidget {
  const GameGiftBonusFeedbackLayer({required this.feedbacks, super.key});

  final List<FloatingBonusFeedback> feedbacks;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.hud(context);
    final style = baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 24) * 0.9,
    );

    return Stack(
      children: [
        for (final feedback in feedbacks)
          Positioned(
            left: feedback.center.dx - 18,
            top: feedback.center.dy,
            child: Opacity(
              opacity: feedback.opacity,
              child: Transform.scale(
                scale: 1 + (feedback.opacity * 0.12),
                child: OutlinedText('+${feedback.points}', style: style),
              ),
            ),
          ),
      ],
    );
  }
}
