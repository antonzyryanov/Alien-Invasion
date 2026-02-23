import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';
import '../../../../app_design/app_dimensions.dart';
import '../../../../app_design/app_durations.dart';
import '../../../../app_design/app_text_styles.dart';

class MenuActionButton extends StatelessWidget {
  const MenuActionButton({
    required this.label,
    required this.onPressed,
    required this.animationIndex,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final int animationIndex;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration:
          AppDurations.menuAnimation +
          Duration(milliseconds: animationIndex * 40),
      curve: Curves.easeInOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.95 + (value * 0.05), child: child),
        );
      },
      child: SizedBox(
        height: AppDimensions.buttonHeight(context),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.menuButton,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.menuButtonRadius(context),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(label, style: AppTextStyles.menuButton(context)),
        ),
      ),
    );
  }
}
