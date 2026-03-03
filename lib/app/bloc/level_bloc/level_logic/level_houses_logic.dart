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
      const renderHouseHeight = 96.0;
      Offset spawnCoord;
      int attempts = 0;
      bool overlaps = false;
      do {
        final x =
            mathRandom.nextDouble() * (state.viewport.width - renderHouseWidth);
        final y = -(300 + mathRandom.nextDouble() * 900);
        spawnCoord = Offset(x, y);
        overlaps = false;

        for (final house in houses) {
          final rectA = Rect.fromLTWH(
            x,
            y,
            renderHouseWidth,
            renderHouseHeight,
          );
          final rectB = Rect.fromLTWH(
            house.center.dx,
            house.center.dy,
            renderHouseWidth,
            renderHouseHeight,
          );
          if (rectA.overlaps(rectB)) {
            overlaps = true;
            break;
          }
        }

        for (final tree in state.dynamicTrees) {
          final rectA = Rect.fromLTWH(
            x,
            y,
            renderHouseWidth,
            renderHouseHeight,
          );
          final rectB = Rect.fromLTWH(tree.center.dx, tree.center.dy, 120, 144);
          if (rectA.overlaps(rectB)) {
            overlaps = true;
            break;
          }
        }

        attempts++;
      } while ((usedCoords.contains(spawnCoord) || overlaps) && attempts < 30);

      usedCoords.add(spawnCoord);
      final speed = 120.0;
      houses.add(
        DynamicHouse(center: spawnCoord, asset: houseAsset, speed: speed),
      );
    }
  }
}
