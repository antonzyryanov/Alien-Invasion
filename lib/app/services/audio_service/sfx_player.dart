import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../app_design/app_audio.dart';
import '../app_logger.dart';

class SfxPlayer {
  AudioPool? _ammunitionSoundPool;
  AudioPool? _ammunitionEncounteredEnemyPool;
  AudioPool? _encounteredGiftPool;
  Future<void> playAmmunitionSound() async {
    await _play(_ammunitionSoundPool);
  }

  Future<void> playAmmunitionEncounteredEnemy() async {
    await _play(_ammunitionEncounteredEnemyPool);
  }

  Future<void> playEncounteredGift() async {
    await _play(_encounteredGiftPool);
  }

  SfxPlayer() {
    unawaited(_ensurePoolsReady());
  }

  Future<void>? _poolsFuture;
  AudioPool? _encounteredEnemyPool;
  AudioPool? _showingScoresPool;
  bool _soundEnabled = true;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playEncounteredEnemy() async {
    await _play(_encounteredEnemyPool);
  }

  Future<void> playShowingScores() async {
    await _play(_showingScoresPool);
  }

  Future<void> _play(AudioPool? pool) async {
    if (!_soundEnabled) {
      return;
    }

    try {
      await _ensurePoolsReady();
      if (pool == null) {
        return;
      }

      await pool.start(volume: AppAudio.sfxVolume);
    } catch (error, stackTrace) {
      appLogger.severe('Failed to play sfx', error, stackTrace);
    }
  }

  Future<void> _ensurePoolsReady() {
    return _poolsFuture ??= _createPools();
  }

  Future<void> _createPools() async {
    final sfxContext = AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build();
    _ammunitionSoundPool = await AudioPool.create(
      source: AssetSource('audio/ammunition_sound.mp3'),
      maxPlayers: 1,
      minPlayers: 1,
      audioContext: sfxContext,
    );

    try {
      _ammunitionEncounteredEnemyPool = await AudioPool.create(
        source: AssetSource('audio/ammunition_encountered_enemy.mp3'),
        maxPlayers: 4,
        minPlayers: 1,
        audioContext: sfxContext,
      );
    } catch (error, stackTrace) {
      appLogger.severe(
        'Failed to load ammunition encountered enemy sfx',
        error,
        stackTrace,
      );
    }

    try {
      _encounteredGiftPool = await AudioPool.create(
        source: AssetSource('audio/encountered_gift.mp3'),
        maxPlayers: 4,
        minPlayers: 1,
        audioContext: sfxContext,
      );
    } catch (error, stackTrace) {
      appLogger.severe(
        'Failed to load encountered gift sfx',
        error,
        stackTrace,
      );
    }

    _encounteredEnemyPool = await AudioPool.create(
      source: AssetSource('audio/encountered_enemy.mp3'),
      maxPlayers: 2,
      minPlayers: 1,
      audioContext: sfxContext,
    );

    _showingScoresPool = await AudioPool.create(
      source: AssetSource('audio/showing_scores.mp3'),
      maxPlayers: 1,
      minPlayers: 1,
      audioContext: sfxContext,
    );
  }

  Future<void> dispose() async {
    await _encounteredEnemyPool?.dispose();
    await _showingScoresPool?.dispose();
    await _ammunitionSoundPool?.dispose();
    await _ammunitionEncounteredEnemyPool?.dispose();
    await _encounteredGiftPool?.dispose();
  }
}
