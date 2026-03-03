part of '../level_bloc.dart';

class LevelGiftsLogic {
  static List<DynamicGift> moveGifts(List<DynamicGift> gifts, double dt) {
    return gifts
        .map(
          (gift) =>
              gift.copyWith(center: gift.center.translate(0, gift.speed * dt)),
        )
        .toList();
  }

  static List<DynamicGift> removeOffscreenGifts(
    List<DynamicGift> gifts,
    Size viewport,
  ) {
    return gifts
        .where((gift) => gift.center.dy < viewport.height + 100)
        .toList();
  }

  static void maybeSpawnGift(
    List<DynamicGift> gifts,
    LevelState state,
    double dt,
    math.Random mathRandom,
    Set<Offset> usedCoords,
    Map<String, double> giftTimers,
  ) {
    if (state.viewport == Size.zero || state.levelType == null) return;

    const maxGifts = 1;
    if (gifts.length >= maxGifts) return;

    final timerKey = 'gift';
    giftTimers[timerKey] = (giftTimers[timerKey] ?? 0) + dt;
    final spawnInterval = 15 + 1 + mathRandom.nextInt(10);

    if (giftTimers[timerKey]! >= spawnInterval) {
      giftTimers[timerKey] = 0;
      const renderGiftWidth = 64.0;

      Offset spawnCoord;
      do {
        final x =
            mathRandom.nextDouble() * (state.viewport.width - renderGiftWidth);
        final y = -(300 + mathRandom.nextDouble() * 600);
        spawnCoord = Offset(x, y);
      } while (usedCoords.contains(spawnCoord));

      usedCoords.add(spawnCoord);
      final speed = 100.0 + 20.0 * state.levelType!.levelDifficulty;
      gifts.add(
        DynamicGift(
          center: spawnCoord,
          asset: state.levelType!.giftAsset,
          speed: speed,
        ),
      );
    }
  }
}
