import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_layout.dart';

abstract final class AppTextStyles {
  static TextStyle menuButton(BuildContext context) => TextStyle(
    fontSize: AppLayout.isDesktop(context)
        ? 28
        : (AppLayout.isTablet(context) ? 24 : 22),
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static TextStyle hud(BuildContext context) => TextStyle(
    fontSize: AppLayout.isDesktop(context)
        ? 30
        : (AppLayout.isTablet(context) ? 26 : 24),
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );

  static TextStyle scoreLarge(BuildContext context) => TextStyle(
    fontSize: AppLayout.isDesktop(context)
        ? 64
        : (AppLayout.isTablet(context) ? 56 : 48),
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );

  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: AppLayout.isDesktop(context)
        ? 42
        : (AppLayout.isTablet(context) ? 36 : 32),
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );

  static TextStyle emptyState(BuildContext context) => TextStyle(
    fontSize: AppLayout.isDesktop(context)
        ? 28
        : (AppLayout.isTablet(context) ? 26 : 24),
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}
