import 'package:flutter/material.dart';

import '../../../../app_design/app_layout.dart';
import '../../../../app_design/app_text_styles.dart';
import '../../../widgets/outlined_text.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.text,
    required this.imagePath,
    super.key,
  });

  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final imageSize = AppLayout.isDesktop(context)
        ? 300.0
        : (AppLayout.isTablet(context) ? 250.0 : 200.0);

    return Column(
      children: [
        const Spacer(),
        OutlinedText(
          text,
          style: AppTextStyles.title(context),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          height: imageSize,
          width: imageSize,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
