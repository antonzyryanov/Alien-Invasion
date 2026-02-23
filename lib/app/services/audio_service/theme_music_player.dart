import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../../app_design/app_audio.dart';
import '../app_logger.dart';
import 'audio_asset_player.dart';

class ThemeMusicPlayer {
  ThemeMusicPlayer() {
    unawaited(_player.setPlayerMode(PlayerMode.mediaPlayer));
  }

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  Future<void> playLoop() async {
    if (_isPlaying) {
      return;
    }

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(AppAudio.musicVolume);
      await AudioAssetPlayer.playAssetWithFallback(
        player: _player,
        assetPath: 'audio/theme_music.mp3',
      );
      _isPlaying = true;
    } catch (error, stackTrace) {
      appLogger.severe('Failed to play theme loop', error, stackTrace);
    }
  }

  Future<void> stop() async {
    if (!_isPlaying) {
      return;
    }

    try {
      await _player.stop();
      _isPlaying = false;
    } catch (error, stackTrace) {
      appLogger.severe('Failed to stop theme music', error, stackTrace);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
