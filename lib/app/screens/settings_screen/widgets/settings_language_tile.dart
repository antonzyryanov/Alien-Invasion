import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';

class SettingsLanguageTile extends StatelessWidget {
  const SettingsLanguageTile({
    required this.title,
    required this.currentLocale,
    required this.englishLabel,
    required this.russianLabel,
    required this.onLocaleChanged,
    super.key,
  });

  final String title;
  final Locale currentLocale;
  final String englishLabel;
  final String russianLabel;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.menuButton,
      child: ListTile(
        title: Text(title),
        subtitle: DropdownButton<Locale>(
          dropdownColor: AppColors.menuButton,
          style: const TextStyle(color: AppColors.white),
          value: currentLocale,
          isExpanded: true,
          onChanged: (locale) {
            if (locale != null) {
              onLocaleChanged(locale);
            }
          },
          items: [
            DropdownMenuItem(
              value: const Locale('en'),
              child: Text(englishLabel),
            ),
            DropdownMenuItem(
              value: const Locale('ru'),
              child: Text(russianLabel),
            ),
          ],
        ),
      ),
    );
  }
}
