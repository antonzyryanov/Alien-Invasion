import 'package:flutter/widgets.dart';

abstract final class AppLayout {
  static const double tabletBreakpoint = 700;
  static const double desktopBreakpoint = 1000;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static double contentMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 620;
    }
    if (isTablet(context)) {
      return 520;
    }
    return 420;
  }

  static double menuContentMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 680;
    }
    if (isTablet(context)) {
      return 560;
    }
    return 460;
  }

  static double secondaryContentMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 700;
    }
    if (isTablet(context)) {
      return 600;
    }
    return 500;
  }

  static double screenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 28;
    }
    if (isTablet(context)) {
      return 22;
    }
    return 16;
  }

  static double menuIconSize(BuildContext context) {
    if (isDesktop(context)) {
      return 108;
    }
    if (isTablet(context)) {
      return 96;
    }
    return 88;
  }

  static double listGap(BuildContext context) {
    return isTablet(context) ? 14 : 12;
  }

  static double hudEdgeInset(BuildContext context) {
    return isTablet(context) ? 18 : 12;
  }

  static double hudTopInset(BuildContext context) {
    return isTablet(context) ? 63 : 40;
  }

  static double bottomActionInset(BuildContext context) {
    return isTablet(context) ? 28 : 20;
  }

  static Size gameOverSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final shipWidth = width * (isTablet(context) ? 0.52 : 0.72);
    final clampedWidth = shipWidth.clamp(300.0, 520.0);
    return Size(clampedWidth, clampedWidth * 0.68);
  }
}
