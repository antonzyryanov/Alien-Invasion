import 'package:flutter/material.dart';

import '../../../../app_design/app_dimensions.dart';
import '../../../../app_design/app_colors.dart';

class NameSubmitButton extends StatelessWidget {
  const NameSubmitButton({
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
      child: FilledButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: AppColors.white)),
      ),
    );
  }
}
