import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_layout.dart';
import '../../../localizations/app_localizations.dart';
import '../../models/score_entry.dart';
import 'widgets/scores_empty_state.dart';
import 'widgets/scores_list_view.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({required this.scores, required this.onBack, super.key});

  final List<ScoreEntry> scores;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.t('bestScores')),
        leading: BackButton(onPressed: onBack),
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
              child: scores.isEmpty
                  ? ScoresEmptyState(text: localizations.t('noScores'))
                  : ScoresListView(scores: scores),
            ),
          ),
        ),
      ),
    );
  }
}
