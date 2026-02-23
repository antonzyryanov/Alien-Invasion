import 'package:audioplayers/audioplayers.dart';

abstract final class AudioAssetPlayer {
  static Future<void> playAssetWithFallback({
    required AudioPlayer player,
    required String assetPath,
  }) async {
    final candidates = <String>{assetPath};
    if (assetPath.startsWith('audio/')) {
      candidates.add(assetPath.replaceFirst('audio/', ''));
    }

    Object? lastError;
    StackTrace? lastStackTrace;
    for (final candidate in candidates) {
      try {
        await player.play(AssetSource(candidate));
        return;
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
      }
    }

    throw Exception(
      'Audio asset failed for all candidates: ${candidates.join(', ')}. Last error: $lastError\n$lastStackTrace',
    );
  }
}
