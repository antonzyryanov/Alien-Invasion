import 'package:flutter/material.dart';

import '../../app_design/app_colors.dart';
import '../../app_design/app_layout.dart';
import '../../app_design/app_text_styles.dart';
import '../../localizations/app_localizations.dart';
import 'outlined_text.dart';

class CreditsWidget extends StatelessWidget {
  const CreditsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final bodyStyle = TextStyle(
      fontSize: AppLayout.isDesktop(context)
          ? 24
          : (AppLayout.isTablet(context) ? 20 : 18),
      fontWeight: FontWeight.w600,
      color: AppColors.white,
      height: 1.35,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppLayout.secondaryContentMaxWidth(context),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppLayout.screenPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: OutlinedText(
                  localizations.t('credits'),
                  style: AppTextStyles.title(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(localizations.t('gameDevelopers'), style: bodyStyle),
              const SizedBox(height: 8),
              Text('Anton Zyryanov', style: bodyStyle),
              const SizedBox(height: 24),
              Text(localizations.t('musicProducers'), style: bodyStyle),
              const SizedBox(height: 8),
              Text(localizations.t('mainThemeCredit'), style: bodyStyle),
              const SizedBox(height: 6),
              Text(localizations.t('levels123Credit'), style: bodyStyle),
              const SizedBox(height: 6),
              Text(localizations.t('level4Credit'), style: bodyStyle),
              const SizedBox(height: 6),
              Text(localizations.t('level5Credit'), style: bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
