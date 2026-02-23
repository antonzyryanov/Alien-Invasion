import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alien_invasion/app/bloc/main_bloc/main_bloc.dart';

import '../models/app_route.dart';
import '../screens/game_screen/game_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/name_screen/name_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/scores_screen/scores_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  AppRouterDelegate({required MainBloc mainBloc}) : _mainBloc = mainBloc {
    _subscription = _mainBloc.stream.listen((_) => notifyListeners());
  }

  final MainBloc _mainBloc;
  StreamSubscription<MainState>? _subscription;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppRoute get currentConfiguration => _mainBloc.state.route;

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    switch (configuration) {
      case AppRoute.enterName:
        break;
      case AppRoute.onboarding:
        _mainBloc.add(
          const MainOpenOnboardingRequested(
            persistOnComplete: false,
            postOnboardingRoute: AppRoute.menu,
          ),
        );
        break;
      case AppRoute.menu:
        _mainBloc.add(const MainOpenMenuRequested());
        break;
      case AppRoute.game:
        break;
      case AppRoute.scores:
        _mainBloc.add(const MainOpenScoresRequested());
        break;
      case AppRoute.settings:
        _mainBloc.add(const MainOpenSettingsRequested());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _mainBloc.state;
    final pages = <Page<void>>[];

    pages.add(
      MaterialPage<void>(
        key: const ValueKey('root-page'),
        child: switch (state.route) {
          AppRoute.enterName => NameScreen(
            onSubmit: (name) => _mainBloc.add(MainPlayerNameSubmitted(name)),
          ),
          AppRoute.onboarding => OnboardingScreen(
            onFinished: () =>
                _mainBloc.add(const MainCompleteOnboardingRequested()),
          ),
          AppRoute.menu => MenuScreen(
            onLevelSelected: (level) =>
                _mainBloc.add(MainStartLevelRequested(level)),
            onScores: () => _mainBloc.add(const MainOpenScoresRequested()),
            onInstructions: () => _mainBloc.add(
              const MainOpenOnboardingRequested(
                persistOnComplete: false,
                postOnboardingRoute: AppRoute.menu,
              ),
            ),
            onSettings: () => _mainBloc.add(const MainOpenSettingsRequested()),
          ),
          AppRoute.game => GameScreen(
            levelBloc: _mainBloc.levelBloc,
            onBackToMenu: () => _mainBloc.add(const MainOpenMenuRequested()),
          ),
          AppRoute.scores => ScoresScreen(
            scores: state.scores,
            onBack: () => _mainBloc.add(const MainOpenMenuRequested()),
          ),
          AppRoute.settings => SettingsScreen(
            currentLocale: state.locale,
            soundEnabled: state.soundEnabled,
            onLocaleChanged: (locale) =>
                _mainBloc.add(MainLanguageChanged(locale)),
            onSoundChanged: (enabled) =>
                _mainBloc.add(MainSoundChanged(enabled)),
            onBack: () => _mainBloc.add(const MainOpenMenuRequested()),
          ),
        },
      ),
    );

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {},
    );
  }

  @override
  Future<bool> popRoute() async {
    if (_mainBloc.state.route == AppRoute.menu ||
        _mainBloc.state.route == AppRoute.enterName) {
      return false;
    }
    _mainBloc.add(const MainOpenMenuRequested());
    return true;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
