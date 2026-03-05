import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class MenuAdBanner extends StatelessWidget {
  const MenuAdBanner({super.key});

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupportedPlatform) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: AppodealBanner(
        adSize: AppodealBannerSize.BANNER,
        placement: 'default',
      ),
    );
  }
}
