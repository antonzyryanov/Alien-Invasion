import 'dart:async';
import 'dart:math' as math;

import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_ammunition.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_enemy.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_cloud.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_tree.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_house.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/level_enemy_frame.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/level_enemy_progress.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/level_ship_frame.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/level_status.dart';
import 'package:alien_invasion/app/bloc/level_bloc/models/level_tick_outcome.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_durations.dart';
import '../../models/level_type.dart';
import '../../services/audio_service/audio_service.dart';
import '../../services/app_logger.dart';

part 'level_event.dart';
part 'level_state.dart';
part 'level_logic/level_ship_logic.dart';
part 'level_logic/level_enemy_logic.dart';
part 'level_logic/level_clouds_logic.dart';
part 'level_logic/level_trees_logic.dart';
part 'level_logic/level_houses_logic.dart';
part 'level_logic/level_tick_coordinator.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  DateTime? _lastAmmoSoundTime;
  void _onAmmunitionFired(
    LevelAmmunitionFired event,
    Emitter<LevelState> emit,
  ) {
    if (!state.isPlayable) return;
    final shipCenter = state.shipCenter;
    final viewport = state.viewport;
    final ammoSpeed = 600.0;
    final ammoSize = AppDimensions.ammunitionSizeForSize(viewport);
    final shipSize = AppDimensions.shipSizeForSize(viewport);

    final Offset ammoCenter = Offset(
      shipCenter.dx,
      shipCenter.dy - (shipSize / 2) - (ammoSize / 2),
    );
    final newAmmo = DynamicAmmunition(center: ammoCenter, speed: ammoSpeed);
    emit(
      state.copyWith(dynamicAmmunition: [...state.dynamicAmmunition, newAmmo]),
    );
    final now = DateTime.now();
    if (_lastAmmoSoundTime == null ||
        now.difference(_lastAmmoSoundTime!) > Duration(milliseconds: 100)) {
      unawaited(_audioService.playAmmunitionSound());
      _lastAmmoSoundTime = now;
    }
  }

  LevelBloc({required AudioService audioService, bool enableTicker = true})
    : _audioService = audioService,
      _shipLogic = _LevelShipLogic(),
      _enemyLogic = _LevelEnemyLogic(),
      super(LevelState.initial()) {
    _tickCoordinator = _LevelTickCoordinator(
      shipLogic: _shipLogic,
      enemyLogic: _enemyLogic,
    );
    on<LevelStartRequested>(_onStartRequested);
    on<LevelTicked>(_onTicked);
    on<LevelGyroUpdated>(_onGyroUpdated);
    on<LevelViewportChanged>(_onViewportChanged);
    on<LevelAmmunitionFired>(_onAmmunitionFired);
    on<LevelResetToMenuRequested>(_onReset);

    _accelerometerSubscription = accelerometerEventStream().listen(
      (event) => add(LevelGyroUpdated(x: event.x, y: event.y)),
      onError: (Object error, StackTrace stackTrace) {
        appLogger.severe('Accelerometer stream error', error, stackTrace);
      },
    );

    if (enableTicker) {
      _ticker = Timer.periodic(
        AppDurations.tick,
        (_) => add(const LevelTicked(0.016)),
      );
    }
  }

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _ticker;
  final AudioService _audioService;
  final _LevelShipLogic _shipLogic;
  final _LevelEnemyLogic _enemyLogic;
  late final _LevelTickCoordinator _tickCoordinator;
  double _tiltX = 0;
  double _tiltY = 0;

  Future<void> _onStartRequested(
    LevelStartRequested event,
    Emitter<LevelState> emit,
  ) async {
    final viewport = state.viewport;
    final center = viewport == Size.zero
        ? const Offset(200, 300)
        : Offset(viewport.width / 2, viewport.height - 80);

    final difficultyLevel = event.levelType.levelDifficulty;
    final maxEnemies = 12 - difficultyLevel;
    final screenWidth = MediaQueryData.fromWindow(
      WidgetsBinding.instance.window,
    ).size.width;
    final enemySize = AppDimensions.enemySizeForSize(viewport);
    final minX = enemySize / 2;
    final maxX = screenWidth - enemySize / 2;
    final mathRandom = math.Random();
    final List<DynamicEnemy> initialEnemies = [];
    final double spacing =
        (maxX - minX) / (maxEnemies > 1 ? maxEnemies - 1 : 1);
    List<double> xPositions = [
      for (int i = 0; i < maxEnemies; i++) minX + i * spacing,
    ];
    xPositions.shuffle(mathRandom);
    for (int i = 0; i < maxEnemies; i++) {
      final x = xPositions[i];
      final y = -(300 + mathRandom.nextDouble() * 900);
      final spawnCoord = Offset(x, y);
      initialEnemies.add(
        DynamicEnemy(
          center: spawnCoord,
          path: EnemyPath.vertical,
          direction: 1.0,
        ),
      );
    }
    emit(
      state.copyWith(
        status: LevelStatus.playing,
        levelType: event.levelType,
        playerName: event.playerName,
        points: 0,
        lives: 3,
        timeLeft: Duration.zero,
        totalDuration: Duration.zero,
        elapsed: Duration.zero,
        shipCenter: center,
        shipVelocity: _LevelShipLogic.initialVelocity,
        enemyDirection: 1,
        finishedAt: null,
        errorMessage: null,
        spawnedEnemyBatches: 0,
        dynamicEnemies: initialEnemies,
      ),
    );
  }

  void _onGyroUpdated(LevelGyroUpdated event, Emitter<LevelState> emit) {
    _tiltX = event.x;
    _tiltY = event.y;
  }

  void _onViewportChanged(
    LevelViewportChanged event,
    Emitter<LevelState> emit,
  ) {
    final viewport = event.size;
    if (viewport == Size.zero) {
      return;
    }

    final shipCenter = Offset(viewport.width / 2, viewport.height - 80);
    emit(state.copyWith(viewport: viewport, shipCenter: shipCenter));
  }

  void _onTicked(LevelTicked event, Emitter<LevelState> emit) {
    try {
      final outcome = _tickCoordinator.coordinate(
        state: state,
        dt: event.deltaSeconds,
        tiltX: _tiltX,
        tiltY: _tiltY,
        now: DateTime.now(),
      );

      if (outcome.playShowingScores) {
        unawaited(_audioService.playShowingScores());
      }
      if (outcome.playEncounteredEnemy) {
        unawaited(_audioService.playEncounteredEnemy());
      }
      if (outcome.playAmmunitionEncounteredEnemy) {
        unawaited(_audioService.playAmmunitionEncounteredEnemy());
      }

      if (outcome.nextState != null) {
        emit(outcome.nextState!);
      }
    } catch (error, stackTrace) {
      appLogger.severe('Level tick failed', error, stackTrace);
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  void _onReset(LevelResetToMenuRequested event, Emitter<LevelState> emit) {
    emit(LevelState.initial().copyWith(viewport: state.viewport));
  }

  @override
  Future<void> close() async {
    await _accelerometerSubscription?.cancel();
    _ticker?.cancel();
    return super.close();
  }
}
