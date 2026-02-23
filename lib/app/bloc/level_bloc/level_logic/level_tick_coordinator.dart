part of '../level_bloc.dart';

class _LevelTickCoordinator {
  const _LevelTickCoordinator({
    required _LevelShipLogic shipLogic,
    required _LevelEnemyLogic enemyLogic,
  }) : _shipLogic = shipLogic,
       _enemyLogic = enemyLogic;

  final _LevelShipLogic _shipLogic;
  final _LevelEnemyLogic _enemyLogic;

  LevelTickOutcome coordinate({
    required LevelState state,
    required double dt,
    required double tiltX,
    required double tiltY,
    required DateTime now,
  }) {
    if (state.levelType == null || state.status == LevelStatus.finished) {
      return LevelTickOutcome.noChange();
    }

    final viewport = state.viewport;
    if (viewport == Size.zero) {
      return LevelTickOutcome.noChange();
    }

    if (state.status == LevelStatus.gameOverShowing) {
      final finishedAt = state.finishedAt;
      if (finishedAt != null &&
          now.difference(finishedAt) >= AppDurations.gameOverDisplay) {
        return LevelTickOutcome(
          nextState: state.copyWith(status: LevelStatus.finished),
          playShowingScores: true,
          playEncounteredEnemy: false,
          playAmmunitionEncounteredEnemy: false,
        );
      }
    }

    final usedCloudCoords = <Offset>{};
    final usedTreeCoords = <Offset>{};
    final usedHouseCoords = <Offset>{};
    final mathRandom = math.Random();

    // Helper: do two line segments intersect?
    bool _linesIntersect(Offset a1, Offset a2, Offset b1, Offset b2) {
      double ccw(Offset A, Offset B, Offset C) {
        return (C.dy - A.dy) * (B.dx - A.dx) - (B.dy - A.dy) * (C.dx - A.dx);
      }

      return (ccw(a1, b1, b2) * ccw(a2, b1, b2) < 0) &&
          (ccw(b1, a1, a2) * ccw(b2, a1, a2) < 0);
    }

    // Helper for swept collision: line segment (with radius) vs rect
    bool _lineIntersectsRect(Offset p1, Offset p2, Rect rect, double radius) {
      // Expand rect by radius
      final expanded = rect.inflate(radius);
      // If either endpoint is inside, it's a hit
      if (expanded.contains(p1) || expanded.contains(p2)) return true;
      // Check intersection with each edge
      final edges = [
        [expanded.topLeft, expanded.topRight],
        [expanded.topRight, expanded.bottomRight],
        [expanded.bottomRight, expanded.bottomLeft],
        [expanded.bottomLeft, expanded.topLeft],
      ];
      for (final edge in edges) {
        if (_linesIntersect(p1, p2, edge[0], edge[1])) return true;
      }
      return false;
    }

    var dynamicClouds = List<DynamicCloud>.from(state.dynamicClouds);
    dynamicClouds = LevelCloudsLogic.removeOffscreenClouds(
      dynamicClouds,
      viewport,
    );
    dynamicClouds = LevelCloudsLogic.moveClouds(dynamicClouds, dt);
    LevelCloudsLogic.maybeSpawnCloud(
      dynamicClouds,
      state,
      dt,
      mathRandom,
      usedCloudCoords,
      state.cloudTimers,
    );

    var dynamicTrees = List<DynamicTree>.from(state.dynamicTrees);
    dynamicTrees = LevelTreesLogic.removeOffscreenTrees(dynamicTrees, viewport);
    dynamicTrees = LevelTreesLogic.moveTrees(dynamicTrees, dt);
    LevelTreesLogic.maybeSpawnTree(
      dynamicTrees,
      state,
      dt,
      mathRandom,
      usedTreeCoords,
      state.treeTimers,
    );

    var dynamicHouses = List<DynamicHouse>.from(state.dynamicHouses);
    dynamicHouses = LevelHousesLogic.removeOffscreenHouses(
      dynamicHouses,
      viewport,
    );
    dynamicHouses = LevelHousesLogic.moveHouses(dynamicHouses, dt);
    LevelHousesLogic.maybeSpawnHouse(
      dynamicHouses,
      state,
      dt,
      mathRandom,
      usedHouseCoords,
      state.houseTimers,
    );

    var dynamicEnemies = List<DynamicEnemy>.from(state.dynamicEnemies);
    int points = state.points;
    int lives = state.lives;
    int spawnedEnemyBatches = state.spawnedEnemyBatches;

    double enemySpawnTimer = state.enemySpawnTimer + dt;
    final double spawnInterval = 2.0;
    List<DynamicEnemy> enemiesToUpdate = List.from(dynamicEnemies);
    if (enemySpawnTimer >= spawnInterval) {
      enemiesToUpdate.add(_LevelEnemyLogic._spawnDynamicEnemy(viewport));
      enemySpawnTimer = 0.0;
    }
    final enemyProgress = _LevelEnemyLogic().progressDynamicEnemies(
      levelDifficulty: state.levelType?.levelDifficulty ?? 1,
      points: points,
      spawnedEnemyBatches: spawnedEnemyBatches,
      dynamicEnemies: enemiesToUpdate,
      viewport: viewport,
      dt: dt,
    );

    List<DynamicEnemy> filteredEnemies = [];
    int enemiesOffscreen = 0;
    for (final enemy in enemyProgress.dynamicEnemies) {
      if (enemy.center.dy >= viewport.height) {
        enemiesOffscreen++;
      } else {
        filteredEnemies.add(enemy);
      }
    }
    int newLives = (lives - enemiesOffscreen).clamp(0, 9999);
    dynamicEnemies = filteredEnemies;
    spawnedEnemyBatches = enemyProgress.spawnedEnemyBatches;

    var dynamicAmmunition = List<DynamicAmmunition>.from(
      state.dynamicAmmunition,
    );
    final enemySize = AppDimensions.enemySizeForSize(viewport);
    final ammoRadius = 16.0;
    final Set<int> hitEnemyIndices = <int>{};
    final Set<int> hitAmmoIndices = <int>{};

    // First pass: detect all collisions and mark indices (swept collision with true previous position)
    for (int i = 0; i < dynamicAmmunition.length; i++) {
      final ammo = dynamicAmmunition[i];
      final prevCenter = ammo.previousCenter ?? ammo.center;
      final nextCenter = ammo.center.translate(0, -ammo.speed * dt);
      dynamicAmmunition[i] = ammo.copyWith(
        center: nextCenter,
        previousCenter: ammo.center,
      );

      if (nextCenter.dy < -ammoRadius) {
        hitAmmoIndices.add(i);
        continue;
      }

      for (int j = 0; j < dynamicEnemies.length; j++) {
        if (hitEnemyIndices.contains(j))
          continue; // Don't double-hit same enemy in one tick
        final enemy = dynamicEnemies[j];
        final enemyRect = Rect.fromCenter(
          center: enemy.center,
          width: enemySize,
          height: enemySize,
        );
        // Check swept collision: if the line from prevCenter to nextCenter intersects enemyRect
        if (_lineIntersectsRect(
          prevCenter,
          nextCenter,
          enemyRect,
          ammoRadius,
        )) {
          hitEnemyIndices.add(j);
          hitAmmoIndices.add(i);
          points += 1;
          break; // One ammo can only hit one enemy per tick
        }
      }
    }

    // Second pass: remove by index after all collisions are detected
    dynamicEnemies = [
      for (int i = 0; i < dynamicEnemies.length; i++)
        if (!hitEnemyIndices.contains(i)) dynamicEnemies[i],
    ];
    dynamicAmmunition = [
      for (int i = 0; i < dynamicAmmunition.length; i++)
        if (!hitAmmoIndices.contains(i)) dynamicAmmunition[i],
    ];

    Offset shipCenter = state.shipCenter;
    Offset shipVelocity = state.shipVelocity;

    if (shipCenter == Offset.zero) {
      shipCenter = Offset(viewport.width / 2, viewport.height - 80);
      shipVelocity = _LevelShipLogic.initialVelocity;
    }

    if (newLives <= 0 && lives > 0 && enemiesOffscreen > 0) {
      return LevelTickOutcome(
        nextState: state.copyWith(
          dynamicClouds: dynamicClouds,
          dynamicTrees: dynamicTrees,
          dynamicHouses: dynamicHouses,
          dynamicEnemies: dynamicEnemies,
          dynamicAmmunition: dynamicAmmunition,
          points: points,
          lives: 0,
          spawnedEnemyBatches: spawnedEnemyBatches,
          shipCenter: shipCenter,
          shipVelocity: shipVelocity,
          enemyDirection: state.enemyDirection,
          status: LevelStatus.gameOverShowing,
          finishedAt: DateTime.now(),
        ),
        playShowingScores: false,
        playEncounteredEnemy: false,
        playAmmunitionEncounteredEnemy: false,
      );
    }

    final enemyFrame = _enemyLogic.advanceFrame(
      state: state,
      dt: dt,
      viewport: viewport,
    );
    final shipFrame = _shipLogic.advanceFrame(
      state: state.copyWith(shipCenter: shipCenter, shipVelocity: shipVelocity),
      dt: dt,
      tiltX: tiltX,
      tiltY: tiltY,
      viewport: viewport,
      enemyRects: enemyFrame.enemyRects,
    );

    var newDynamicEnemies = List<DynamicEnemy>.from(dynamicEnemies);
    bool gameOver = false;
    if (shipFrame.hitEnemy) {
      newLives = (lives - 1).clamp(0, 9999);
      final hitIndex = newDynamicEnemies.indexWhere(
        (enemy) => Rect.fromCenter(
          center: enemy.center,
          width: AppDimensions.enemySizeForSize(viewport),
          height: AppDimensions.enemySizeForSize(viewport),
        ).contains(shipFrame.shipCenter),
      );
      if (hitIndex != -1) {
        newDynamicEnemies.removeAt(hitIndex);
      }
      if (newLives <= 0) {
        gameOver = true;
      }
    }

    if (gameOver) {
      return LevelTickOutcome(
        nextState: state.copyWith(
          dynamicClouds: dynamicClouds,
          dynamicTrees: dynamicTrees,
          dynamicHouses: dynamicHouses,
          dynamicEnemies: newDynamicEnemies,
          dynamicAmmunition: dynamicAmmunition,
          lives: 0,
          spawnedEnemyBatches: spawnedEnemyBatches,
          shipCenter: shipFrame.shipCenter,
          shipVelocity: shipFrame.shipVelocity,
          enemyDirection: enemyFrame.enemyDirection,
          status: LevelStatus.gameOverShowing,
          finishedAt: DateTime.now(),
        ),
        playShowingScores: false,
        playEncounteredEnemy: true,
        playAmmunitionEncounteredEnemy: false,
      );
    }

    final bool shouldIncrementElapsed =
        state.status == LevelStatus.playing && newLives > 0;
    final Duration newElapsed = shouldIncrementElapsed
        ? state.elapsed + Duration(milliseconds: (dt * 1000).round())
        : state.elapsed;

    bool ammunitionHitEnemy = false;
    for (final ammo in dynamicAmmunition) {
      for (final enemy in newDynamicEnemies) {
        final ammoRect = Rect.fromCenter(
          center: ammo.center,
          width: AppDimensions.ammunitionSizeForSize(viewport),
          height: AppDimensions.ammunitionSizeForSize(viewport),
        );
        final enemyRect = Rect.fromCenter(
          center: enemy.center,
          width: AppDimensions.enemySizeForSize(viewport),
          height: AppDimensions.enemySizeForSize(viewport),
        );
        if (ammoRect.overlaps(enemyRect)) {
          ammunitionHitEnemy = true;
          break;
        }
      }
      if (ammunitionHitEnemy) break;
    }

    return LevelTickOutcome(
      nextState: state.copyWith(
        dynamicClouds: dynamicClouds,
        dynamicTrees: dynamicTrees,
        dynamicHouses: dynamicHouses,
        dynamicEnemies: newDynamicEnemies,
        dynamicAmmunition: dynamicAmmunition,
        points: points,
        lives: newLives,
        spawnedEnemyBatches: spawnedEnemyBatches,
        shipCenter: shipFrame.shipCenter,
        shipVelocity: shipFrame.shipVelocity,
        enemyDirection: enemyFrame.enemyDirection,
        enemySpawnTimer: enemySpawnTimer,
        elapsed: newElapsed,
      ),
      playShowingScores: false,
      playEncounteredEnemy: shipFrame.hitEnemy,
      playAmmunitionEncounteredEnemy: ammunitionHitEnemy,
    );
  }
}
