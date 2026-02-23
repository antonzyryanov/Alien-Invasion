import 'package:flutter/material.dart';

import '../../../../app_design/app_text_styles.dart';

class ScoresEmptyState extends StatelessWidget {
  const ScoresEmptyState({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: AppTextStyles.emptyState(context)));
  }
}
