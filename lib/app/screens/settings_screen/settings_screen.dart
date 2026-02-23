import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_layout.dart';
import '../../../localizations/app_localizations.dart';
import 'widgets/settings_language_tile.dart';
import 'widgets/settings_sound_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.currentLocale,
    required this.soundEnabled,
    required this.onLocaleChanged,
    required this.onSoundChanged,
    required this.onBack,
    super.key,
  });

  final Locale currentLocale;
  final bool soundEnabled;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<bool> onSoundChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: Text(localizations.t('settings')),
      ),
      body: Container(
        color: AppColors.menuBackground,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppLayout.secondaryContentMaxWidth(context),
            ),
            child: ListTileTheme(
              textColor: AppColors.white,
              iconColor: AppColors.white,
              child: ListView(
                padding: EdgeInsets.all(AppLayout.screenPadding(context)),
                children: [
                  SettingsSoundTile(
                    title: localizations.t('sound'),
                    value: soundEnabled,
                    onChanged: onSoundChanged,
                  ),
                  SettingsLanguageTile(
                    title: localizations.t('language'),
                    currentLocale: currentLocale,
                    englishLabel: localizations.t('english'),
                    russianLabel: localizations.t('russian'),
                    onLocaleChanged: onLocaleChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
