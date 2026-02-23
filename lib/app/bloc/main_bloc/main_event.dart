part of 'main_bloc.dart';

sealed class MainEvent {
  const MainEvent();
}

final class MainStarted extends MainEvent {
  const MainStarted();
}

final class MainPlayerNameSubmitted extends MainEvent {
  const MainPlayerNameSubmitted(this.playerName);

  final String playerName;
}

final class MainOpenOnboardingRequested extends MainEvent {
  const MainOpenOnboardingRequested({
    required this.persistOnComplete,
    required this.postOnboardingRoute,
  });

  final bool persistOnComplete;
  final AppRoute postOnboardingRoute;
}

final class MainCompleteOnboardingRequested extends MainEvent {
  const MainCompleteOnboardingRequested();
}

final class MainOpenMenuRequested extends MainEvent {
  const MainOpenMenuRequested();
}

final class MainOpenSettingsRequested extends MainEvent {
  const MainOpenSettingsRequested();
}

final class MainOpenScoresRequested extends MainEvent {
  const MainOpenScoresRequested();
}

final class MainStartLevelRequested extends MainEvent {
  const MainStartLevelRequested(this.levelType);

  final LevelType levelType;
}

final class MainLanguageChanged extends MainEvent {
  const MainLanguageChanged(this.locale);

  final Locale locale;
}

final class MainSoundChanged extends MainEvent {
  const MainSoundChanged(this.enabled);

  final bool enabled;
}

final class MainPersistCurrentResultRequested extends MainEvent {
  const MainPersistCurrentResultRequested();
}
