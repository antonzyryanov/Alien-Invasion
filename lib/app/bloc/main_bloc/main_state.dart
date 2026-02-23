part of 'main_bloc.dart';

class MainState extends Equatable {
  const MainState({
    required this.route,
    required this.playerName,
    required this.locale,
    required this.soundEnabled,
    required this.shouldPersistOnboarding,
    required this.postOnboardingRoute,
    required this.scores,
    required this.errorMessage,
  });

  factory MainState.initial() => const MainState(
    route: AppRoute.enterName,
    playerName: '',
    locale: Locale('en'),
    soundEnabled: true,
    shouldPersistOnboarding: false,
    postOnboardingRoute: AppRoute.enterName,
    scores: [],
    errorMessage: null,
  );

  final AppRoute route;
  final String playerName;
  final Locale locale;
  final bool soundEnabled;
  final bool shouldPersistOnboarding;
  final AppRoute postOnboardingRoute;
  final List<ScoreEntry> scores;
  final String? errorMessage;

  MainState copyWith({
    AppRoute? route,
    String? playerName,
    Locale? locale,
    bool? soundEnabled,
    bool? shouldPersistOnboarding,
    AppRoute? postOnboardingRoute,
    List<ScoreEntry>? scores,
    String? errorMessage,
  }) {
    return MainState(
      route: route ?? this.route,
      playerName: playerName ?? this.playerName,
      locale: locale ?? this.locale,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      shouldPersistOnboarding:
          shouldPersistOnboarding ?? this.shouldPersistOnboarding,
      postOnboardingRoute: postOnboardingRoute ?? this.postOnboardingRoute,
      scores: scores ?? this.scores,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    route,
    playerName,
    locale,
    soundEnabled,
    shouldPersistOnboarding,
    postOnboardingRoute,
    scores,
    errorMessage,
  ];
}
