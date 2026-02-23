part of '../level_bloc.dart';

class LevelHousesLogic {
  static List<DynamicHouse> moveHouses(List<DynamicHouse> houses, double dt) {
    return houses
        .map(
          (house) => house.copyWith(
            center: house.center.translate(0, house.speed * dt),
          ),
        )
        .toList();
  }

  static List<DynamicHouse> removeOffscreenHouses(
    List<DynamicHouse> houses,
    Size viewport,
  ) {
    return houses
        .where((house) => house.center.dy < viewport.height + 100)
        .toList();
  }

  static void maybeSpawnHouse(
    List<DynamicHouse> houses,
    LevelState state,
    double dt,
    math.Random mathRandom,
    Set<Offset> usedCoords,
    Map<String, double> houseTimers,
  ) {
    if (state.viewport == Size.zero) return;
    final maxHouses = 2 + mathRandom.nextInt(4);
    if (houses.length >= maxHouses) return;
    final timerKey = 'house';
    houseTimers[timerKey] = (houseTimers[timerKey] ?? 0) + dt;
    final spawnInterval = 1 + mathRandom.nextInt(10);
    if (houseTimers[timerKey]! >= spawnInterval) {
      houseTimers[timerKey] = 0;
      final city = state.levelType!.city;
      final houseIdx = 1 + mathRandom.nextInt(3);
      final houseAsset =
          'assets/images/cities/city_${city}/house_${houseIdx}.png';
      const renderHouseWidth = 120.0;
      final screenWidth = MediaQueryData.fromWindow(
        WidgetsBinding.instance.window,
      ).size.width;
      final slotCount = (screenWidth / renderHouseWidth).floor();
      final List<int> occupiedSlots = [];
      for (final house in houses) {
        final slot = (house.center.dx / renderHouseWidth).floor();
        occupiedSlots.add(slot);
      }
      for (final tree in state.dynamicTrees) {
        final slot = (tree.center.dx / renderHouseWidth).floor();
        occupiedSlots.add(slot);
      }
      final availableSlots = List<int>.generate(slotCount, (i) => i)
        ..removeWhere((i) => occupiedSlots.contains(i));
      if (availableSlots.isEmpty) return;
      final slot = availableSlots[mathRandom.nextInt(availableSlots.length)];
      final x = slot * renderHouseWidth;
      final y = -100.0;
      final spawnCoord = Offset(x, y);
      usedCoords.add(spawnCoord);
      final speed = 120.0;
      houses.add(
        DynamicHouse(center: spawnCoord, asset: houseAsset, speed: speed),
      );
    }
  }
}
