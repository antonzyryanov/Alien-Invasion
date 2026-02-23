import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';
import '../../../../app_design/app_dimensions.dart';

class NameInputField extends StatelessWidget {
  const NameInputField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: AppColors.menuButton,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.white,
            width: AppDimensions.focusedInputBorderWidth(context),
          ),
        ),
      ),
    );
  }
}
