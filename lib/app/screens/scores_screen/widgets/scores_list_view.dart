import 'package:flutter/material.dart';

import '../../../../app_design/app_colors.dart';
import '../../../../app_design/app_layout.dart';
import '../../../models/score_entry.dart';

class ScoresListView extends StatelessWidget {
  const ScoresListView({required this.scores, super.key});

  final List<ScoreEntry> scores;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppLayout.screenPadding(context)),
      itemCount: scores.length,
      separatorBuilder: (_, _) => const Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        final score = scores[index];
        return _ScoreListItem(score: score);
      },
    );
  }
}

class _ScoreListItem extends StatelessWidget {
  const _ScoreListItem({required this.score});

  final ScoreEntry score;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.menuButton,
      child: ListTile(
        title: Text(score.name, style: const TextStyle(color: AppColors.white)),
        trailing: Text(
          score.value.round().toString(),
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
