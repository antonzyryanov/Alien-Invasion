part of '../level_bloc.dart';

class LevelCloudsLogic {
  static List<DynamicCloud> moveClouds(List<DynamicCloud> clouds, double dt) {
    return clouds
        .map(
          (cloud) => cloud.copyWith(
            center: cloud.center.translate(0, cloud.speed * dt),
          ),
        )
        .toList();
  }

  static List<DynamicCloud> removeOffscreenClouds(
    List<DynamicCloud> clouds,
    Size viewport,
  ) {
    return clouds
        .where((cloud) => cloud.center.dy < viewport.height + 100)
        .toList();
  }

  static void maybeSpawnCloud(
    List<DynamicCloud> clouds,
    LevelState state,
    double dt,
    math.Random mathRandom,
    Set<Offset> usedCoords,
    Map<String, double> cloudTimers,
  ) {
    if (state.viewport == Size.zero) return;
    final maxClouds = 4 + mathRandom.nextInt(5);
    if (clouds.length >= maxClouds) return;
    final timerKey = 'cloud';
    cloudTimers[timerKey] = (cloudTimers[timerKey] ?? 0) + dt;
    final spawnInterval = 1 + mathRandom.nextInt(5);
    if (cloudTimers[timerKey]! >= spawnInterval) {
      cloudTimers[timerKey] = 0;
      final cloudAsset =
          'assets/images/clouds/clouds_${1 + mathRandom.nextInt(5)}.png';
      const renderCloudWidth = 120.0;
      Offset spawnCoord;
      do {
        final screenWidth = MediaQueryData.fromWindow(
          WidgetsBinding.instance.window,
        ).size.width;
        final x = mathRandom.nextDouble() * (screenWidth - renderCloudWidth);
        final y = -100.0;
        spawnCoord = Offset(x, y);
      } while (usedCoords.contains(spawnCoord));
      usedCoords.add(spawnCoord);
      final speed = 120.0 + 20.0 * (state.levelType!.levelDifficulty);
      clouds.add(
        DynamicCloud(center: spawnCoord, asset: cloudAsset, speed: speed),
      );
    }
  }
}
