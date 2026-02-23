part of '../level_bloc.dart';

class LevelTreesLogic {
  static List<DynamicTree> moveTrees(List<DynamicTree> trees, double dt) {
    return trees
        .map(
          (tree) =>
              tree.copyWith(center: tree.center.translate(0, tree.speed * dt)),
        )
        .toList();
  }

  static List<DynamicTree> removeOffscreenTrees(
    List<DynamicTree> trees,
    Size viewport,
  ) {
    return trees
        .where((tree) => tree.center.dy < viewport.height + 100)
        .toList();
  }

  static void maybeSpawnTree(
    List<DynamicTree> trees,
    LevelState state,
    double dt,
    math.Random mathRandom,
    Set<Offset> usedCoords,
    Map<String, double> treeTimers,
  ) {
    if (state.viewport == Size.zero) return;
    final maxTrees = 3 + mathRandom.nextInt(5);
    if (trees.length >= maxTrees) return;
    final timerKey = 'tree';
    treeTimers[timerKey] = (treeTimers[timerKey] ?? 0) + dt;
    final spawnInterval = 1 + mathRandom.nextInt(10);
    if (treeTimers[timerKey]! >= spawnInterval) {
      treeTimers[timerKey] = 0;
      final treeAsset = state.levelType!.treeAsset;
      // Unique x/y coordinates, prevent overlap with trees and houses
      const renderTreeWidth = 120.0;
      const renderTreeHeight = 72.0;
      Offset spawnCoord;
      int attempts = 0;
      bool overlaps = false;
      do {
        final screenWidth = MediaQueryData.fromWindow(
          WidgetsBinding.instance.window,
        ).size.width;
        final x = mathRandom.nextDouble() * (screenWidth - renderTreeWidth);
        final y = -100.0;
        spawnCoord = Offset(x, y);
        overlaps = false;
        // Check overlap with all existing trees
        for (final tree in trees) {
          final rectA = Rect.fromLTWH(x, y, renderTreeWidth, renderTreeHeight);
          final rectB = Rect.fromLTWH(
            tree.center.dx,
            tree.center.dy,
            renderTreeWidth,
            renderTreeHeight,
          );
          if (rectA.overlaps(rectB)) {
            overlaps = true;
            break;
          }
        }
        // Check overlap with all existing houses
        for (final house in state.dynamicHouses) {
          final rectA = Rect.fromLTWH(x, y, renderTreeWidth, renderTreeHeight);
          final rectB = Rect.fromLTWH(
            house.center.dx,
            house.center.dy,
            120.0,
            96.0,
          );
          if (rectA.overlaps(rectB)) {
            overlaps = true;
            break;
          }
        }
        attempts++;
      } while ((usedCoords.contains(spawnCoord) || overlaps) && attempts < 30);
      usedCoords.add(spawnCoord);
      final speed = 120.0;
      trees.add(
        DynamicTree(center: spawnCoord, asset: treeAsset, speed: speed),
      );
    }
  }
}
