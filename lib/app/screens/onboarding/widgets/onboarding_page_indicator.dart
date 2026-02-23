import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.totalPages,
    required this.currentPageIndex,
    super.key,
  });

  final int totalPages;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : AppColors.black,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
