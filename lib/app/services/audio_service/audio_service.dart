import 'dart:async';

import 'level_music_player.dart';
import 'sfx_player.dart';
import 'theme_music_player.dart';

class AudioService {
  Future<void> playAmmunitionSound() async {
    await _sfxPlayer.playAmmunitionSound();
  }

  Future<void> playAmmunitionEncounteredEnemy() async {
    await _sfxPlayer.playAmmunitionEncounteredEnemy();
  }

  AudioService({
    ThemeMusicPlayer? themeMusicPlayer,
    LevelMusicPlayer? levelMusicPlayer,
    SfxPlayer? sfxPlayer,
  }) : _themeMusicPlayer = themeMusicPlayer ?? ThemeMusicPlayer(),
       _levelMusicPlayer = levelMusicPlayer ?? LevelMusicPlayer(),
       _sfxPlayer = sfxPlayer ?? SfxPlayer();

  final ThemeMusicPlayer _themeMusicPlayer;
  final LevelMusicPlayer _levelMusicPlayer;
  final SfxPlayer _sfxPlayer;
  bool _soundEnabled = true;

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    _sfxPlayer.setSoundEnabled(enabled);
    await _levelMusicPlayer.setSoundEnabled(enabled);
    if (!enabled) {
      await stopThemeMusic();
    }
  }

  Future<void> playThemeMusicLoop() async {
    if (!_soundEnabled) {
      return;
    }

    await _levelMusicPlayer.stopLoop();
    await _themeMusicPlayer.playLoop();
  }

  Future<void> stopThemeMusic() async {
    await _themeMusicPlayer.stop();
  }

  Future<void> playLevelMusicLoop() async {
    if (!_soundEnabled) {
      return;
    }

    await _themeMusicPlayer.stop();
    await _levelMusicPlayer.playLoop();
  }

  Future<void> stopLevelMusic() async {
    await _levelMusicPlayer.stopLoop();
  }

  Future<void> playEncounteredEnemy() async {
    await _sfxPlayer.playEncounteredEnemy();
    unawaited(_levelMusicPlayer.restoreIfInterrupted());
  }

  Future<void> playShowingScores() async {
    await _sfxPlayer.playShowingScores();
    unawaited(_levelMusicPlayer.restoreIfInterrupted());
  }

  Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _themeMusicPlayer.dispose();
    await _levelMusicPlayer.dispose();
  }
}
