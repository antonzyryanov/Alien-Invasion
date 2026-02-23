part of 'level_bloc.dart';

sealed class LevelEvent {
  const LevelEvent();
}

final class LevelStartRequested extends LevelEvent {
  const LevelStartRequested({
    required this.levelType,
    required this.playerName,
  });

  final LevelType levelType;
  final String playerName;
}

final class LevelTicked extends LevelEvent {
  const LevelTicked(this.deltaSeconds);

  final double deltaSeconds;
}

final class LevelGyroUpdated extends LevelEvent {
  const LevelGyroUpdated({required this.x, required this.y});

  final double x;
  final double y;
}

final class LevelViewportChanged extends LevelEvent {
  const LevelViewportChanged(this.size);

  final Size size;
}

final class LevelAmmunitionFired extends LevelEvent {
  const LevelAmmunitionFired();
}

final class LevelResetToMenuRequested extends LevelEvent {
  const LevelResetToMenuRequested();
}
