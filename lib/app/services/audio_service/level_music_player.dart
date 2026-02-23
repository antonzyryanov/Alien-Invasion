import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../app_design/app_audio.dart';
import '../app_logger.dart';
import 'audio_asset_player.dart';

class LevelMusicPlayer {
  LevelMusicPlayer() {
    unawaited(_player.setPlayerMode(PlayerMode.mediaPlayer));
    _stateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!_shouldKeepLoop || !_soundEnabled) {
        return;
      }

      if (state == PlayerState.stopped ||
          state == PlayerState.paused ||
          state == PlayerState.completed) {
        unawaited(_restartLoopIfNeeded());
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _stateSubscription;
  bool _isPlaying = false;
  bool _soundEnabled = true;
  bool _shouldKeepLoop = false;
  bool _isRestartingLoop = false;

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    if (!enabled) {
      await stopLoop();
    }
  }

  Future<void> playLoop() async {
    _shouldKeepLoop = true;
    if (!_soundEnabled || _isPlaying) {
      return;
    }

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(AppAudio.musicVolume);
      await AudioAssetPlayer.playAssetWithFallback(
        player: _player,
        assetPath: 'audio/level_music.mp3',
      );
      _isPlaying = true;
    } catch (error, stackTrace) {
      appLogger.severe('Failed to play level loop', error, stackTrace);
    }
  }

  Future<void> stopLoop() async {
    _shouldKeepLoop = false;
    if (!_isPlaying) {
      return;
    }

    try {
      await _player.stop();
      _isPlaying = false;
    } catch (error, stackTrace) {
      appLogger.severe('Failed to stop level music', error, stackTrace);
    }
  }

  Future<void> restoreIfInterrupted() async {
    if (!_isPlaying || !_shouldKeepLoop) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!_isPlaying || !_soundEnabled || !_shouldKeepLoop) {
      return;
    }

    try {
      if (_player.state == PlayerState.playing) {
        return;
      }

      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(AppAudio.musicVolume);
      await AudioAssetPlayer.playAssetWithFallback(
        player: _player,
        assetPath: 'audio/level_music.mp3',
      );
    } catch (error, stackTrace) {
      appLogger.severe('Failed to restore level music', error, stackTrace);
    }
  }

  Future<void> _restartLoopIfNeeded() async {
    if (_isRestartingLoop || !_shouldKeepLoop || !_soundEnabled) {
      return;
    }

    _isRestartingLoop = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      if (!_shouldKeepLoop || !_soundEnabled) {
        return;
      }

      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(AppAudio.musicVolume);
      await AudioAssetPlayer.playAssetWithFallback(
        player: _player,
        assetPath: 'audio/level_music.mp3',
      );
      _isPlaying = true;
    } catch (error, stackTrace) {
      appLogger.severe('Failed to restart level loop', error, stackTrace);
    } finally {
      _isRestartingLoop = false;
    }
  }

  Future<void> dispose() async {
    await _stateSubscription?.cancel();
    await _player.dispose();
  }
}
