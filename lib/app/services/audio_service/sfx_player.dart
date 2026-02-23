import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../app_design/app_audio.dart';
import '../app_logger.dart';

class SfxPlayer {
  AudioPool? _ammunitionSoundPool;
  AudioPool? _ammunitionEncounteredEnemyPool;
  Future<void> playAmmunitionSound() async {
    await _play(_ammunitionSoundPool);
  }

  Future<void> playAmmunitionEncounteredEnemy() async {
    print('[SFX DEBUG] playAmmunitionEncounteredEnemy called');
    await _play(_ammunitionEncounteredEnemyPool);
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
    try {
      print('[SFX DEBUG] Loading ammunition_sound.mp3');
      _ammunitionSoundPool = await AudioPool.create(
        source: AssetSource('audio/ammunition_sound.mp3'),
        maxPlayers: 2,
        minPlayers: 1,
        audioContext: sfxContext,
      );
      print('[SFX DEBUG] Loaded ammunition_sound.mp3');
    } catch (e) {
      print('[SFX ERROR] Failed to load ammunition_sound.mp3: $e');
    }
    try {
      print('[SFX DEBUG] Loading ammunition_encountered_enemy.mp3');
      _ammunitionEncounteredEnemyPool = await AudioPool.create(
        source: AssetSource('audio/ammunition_encountered_enemy.mp3'),
        maxPlayers: 4,
        minPlayers: 1,
        audioContext: sfxContext,
      );
      print('[SFX DEBUG] Loaded ammunition_encounted_enemy.mp3');
    } catch (e) {
      print('[SFX ERROR] Failed to load ammunition_encounted_enemy.mp3: $e');
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
  }
}
