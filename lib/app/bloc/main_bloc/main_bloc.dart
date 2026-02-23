import 'dart:async';

import 'package:alien_invasion/app/bloc/level_bloc/models/level_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alien_invasion/app/bloc/level_bloc/level_bloc.dart';
import 'package:alien_invasion/app/models/app_route.dart';
import 'package:alien_invasion/app/models/level_type.dart';
import 'package:alien_invasion/app/models/score_entry.dart';
import 'package:alien_invasion/app/repositories/score_repository.dart';
import 'package:alien_invasion/app/services/audio_service/audio_service.dart';
import 'package:alien_invasion/app/services/app_logger.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({
    required ScoreRepository scoreRepository,
    bool enableLevelTicker = true,
  }) : this._(
         scoreRepository: scoreRepository,
         audioService: AudioService(),
         enableLevelTicker: enableLevelTicker,
       );

  MainBloc._({
    required ScoreRepository scoreRepository,
    required AudioService audioService,
    required bool enableLevelTicker,
  }) : _scoreRepository = scoreRepository,
       _audioService = audioService,
       levelBloc = LevelBloc(
         audioService: audioService,
         enableTicker: enableLevelTicker,
       ),
       super(MainState.initial()) {
    on<MainStarted>(_onStarted);
    on<MainPlayerNameSubmitted>(_onPlayerNameSubmitted);
    on<MainOpenOnboardingRequested>(_onOpenOnboarding);
    on<MainCompleteOnboardingRequested>(_onCompleteOnboarding);
    on<MainOpenMenuRequested>(_onOpenMenu);
    on<MainOpenSettingsRequested>(_onOpenSettings);
    on<MainOpenScoresRequested>(_onOpenScores);
    on<MainStartLevelRequested>(_onStartLevel);
    on<MainLanguageChanged>(_onLanguageChanged);
    on<MainSoundChanged>(_onSoundChanged);
    on<MainPersistCurrentResultRequested>(_onPersistCurrentResult);

    _levelSubscription = levelBloc.stream.listen((levelState) {
      if (levelState.status == LevelStatus.finished &&
          _lastObservedLevelStatus != LevelStatus.finished) {
        add(const MainPersistCurrentResultRequested());
      }
      _lastObservedLevelStatus = levelState.status;
    });
  }

  final ScoreRepository _scoreRepository;
  final AudioService _audioService;
  final LevelBloc levelBloc;
  StreamSubscription<LevelState>? _levelSubscription;
  LevelStatus _lastObservedLevelStatus = LevelStatus.idle;
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _onboardingShownKey = 'isOnboardingShown';

  Future<void> _onStarted(MainStarted event, Emitter<MainState> emit) async {
    final preferences = await SharedPreferences.getInstance();
    final soundEnabled = preferences.getBool(_soundEnabledKey) ?? true;
    final isOnboardingShown = preferences.getBool(_onboardingShownKey) ?? false;
    await _audioService.setSoundEnabled(soundEnabled);
    emit(
      state.copyWith(
        soundEnabled: soundEnabled,
        route: isOnboardingShown ? AppRoute.enterName : AppRoute.onboarding,
        shouldPersistOnboarding: !isOnboardingShown,
        postOnboardingRoute: AppRoute.enterName,
      ),
    );
    await _refreshScores(emit);
  }

  void _onOpenOnboarding(
    MainOpenOnboardingRequested event,
    Emitter<MainState> emit,
  ) {
    emit(
      state.copyWith(
        route: AppRoute.onboarding,
        shouldPersistOnboarding: event.persistOnComplete,
        postOnboardingRoute: event.postOnboardingRoute,
      ),
    );
  }

  Future<void> _onCompleteOnboarding(
    MainCompleteOnboardingRequested event,
    Emitter<MainState> emit,
  ) async {
    if (state.shouldPersistOnboarding) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_onboardingShownKey, true);
    }
    emit(
      state.copyWith(
        route: state.postOnboardingRoute,
        shouldPersistOnboarding: false,
        postOnboardingRoute: AppRoute.enterName,
      ),
    );
  }

  void _onPlayerNameSubmitted(
    MainPlayerNameSubmitted event,
    Emitter<MainState> emit,
  ) {
    if (state.soundEnabled) {
      unawaited(_audioService.playThemeMusicLoop());
    }
    emit(
      state.copyWith(playerName: event.playerName.trim(), route: AppRoute.menu),
    );
  }

  void _onOpenMenu(MainOpenMenuRequested event, Emitter<MainState> emit) {
    unawaited(_audioService.stopLevelMusic());
    if (state.soundEnabled) {
      unawaited(_audioService.playThemeMusicLoop());
    }
    levelBloc.add(const LevelResetToMenuRequested());
    emit(state.copyWith(route: AppRoute.menu));
  }

  void _onOpenSettings(
    MainOpenSettingsRequested event,
    Emitter<MainState> emit,
  ) {
    emit(state.copyWith(route: AppRoute.settings));
  }

  Future<void> _onOpenScores(
    MainOpenScoresRequested event,
    Emitter<MainState> emit,
  ) async {
    await _refreshScores(emit);
    emit(state.copyWith(route: AppRoute.scores));
  }

  void _onStartLevel(MainStartLevelRequested event, Emitter<MainState> emit) {
    unawaited(_audioService.stopThemeMusic());
    if (state.soundEnabled) {
      unawaited(_audioService.playLevelMusicLoop());
    }
    levelBloc.add(
      LevelStartRequested(
        levelType: event.levelType,
        playerName: state.playerName,
      ),
    );
    emit(state.copyWith(route: AppRoute.game));
  }

  void _onLanguageChanged(MainLanguageChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onSoundChanged(
    MainSoundChanged event,
    Emitter<MainState> emit,
  ) async {
    await _audioService.setSoundEnabled(event.enabled);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundEnabledKey, event.enabled);
    emit(state.copyWith(soundEnabled: event.enabled));
    if (event.enabled) {
      if (state.route == AppRoute.menu) {
        unawaited(_audioService.playThemeMusicLoop());
      } else if (state.route == AppRoute.game) {
        unawaited(_audioService.playLevelMusicLoop());
      }
    }
  }

  Future<void> _onPersistCurrentResult(
    MainPersistCurrentResultRequested event,
    Emitter<MainState> emit,
  ) async {
    try {
      final levelState = levelBloc.state;
      if (levelState.playerName.isEmpty) {
        return;
      }
      final score = levelState.points.toDouble();
      await _scoreRepository.upsertScore(
        playerName: levelState.playerName,
        score: score,
      );
      await _refreshScores(emit);
    } catch (error, stackTrace) {
      appLogger.severe('Failed to persist result', error, stackTrace);
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> _refreshScores(Emitter<MainState> emit) async {
    try {
      final scores = await _scoreRepository.readSortedScores();
      emit(state.copyWith(scores: scores, errorMessage: null));
    } catch (error, stackTrace) {
      appLogger.severe('Failed to read scores', error, stackTrace);
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _levelSubscription?.cancel();
    await _audioService.dispose();
    await levelBloc.close();
    return super.close();
  }
}
