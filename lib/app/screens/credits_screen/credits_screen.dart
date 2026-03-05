import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../localizations/app_localizations.dart';
import '../../widgets/credits_widget.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: Text(localizations.t('credits')),
      ),
      body: Container(
        color: AppColors.menuBackground,
        child: const SafeArea(child: CreditsWidget()),
      ),
    );
  }
}
