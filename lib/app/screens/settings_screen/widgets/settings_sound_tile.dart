import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';

class SettingsSoundTile extends StatelessWidget {
  const SettingsSoundTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.menuButton,
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.white,
      ),
    );
  }
}
