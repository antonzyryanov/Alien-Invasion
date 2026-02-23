import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';
import '../../../../app_design/app_dimensions.dart';
import '../../../../app_design/app_text_styles.dart';
import '../../../widgets/outlined_text.dart';

class OnboardingContinueButton extends StatelessWidget {
  const OnboardingContinueButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
        child: OutlinedText(label, style: AppTextStyles.menuButton(context)),
      ),
    );
  }
}
