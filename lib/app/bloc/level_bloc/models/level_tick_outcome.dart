import 'package:alien_invasion/app/bloc/level_bloc/level_bloc.dart';

class LevelTickOutcome {
  const LevelTickOutcome({
    required this.nextState,
    required this.playShowingScores,
    required this.playEncounteredEnemy,
    required this.playAmmunitionEncounteredEnemy,
  });

  factory LevelTickOutcome.noChange() => const LevelTickOutcome(
    nextState: null,
    playShowingScores: false,
    playEncounteredEnemy: false,
    playAmmunitionEncounteredEnemy: false,
  );

  final LevelState? nextState;
  final bool playShowingScores;
  final bool playEncounteredEnemy;
  final bool playAmmunitionEncounteredEnemy;
}
