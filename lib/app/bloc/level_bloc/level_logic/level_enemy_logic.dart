part of '../level_bloc.dart';

class _LevelEnemyLogic {
  static final math.Random _random = math.Random();
  static const double _baseEnemySpeed = 80;

  static double _dynamicEnemySpeed(int difficulty, int killed) {
    return _baseEnemySpeed + (killed ~/ (10 - difficulty)) * 30;
  }

  static DynamicEnemy _moveDynamicEnemy(
    DynamicEnemy enemy,
    Size viewport,
    double dt,
    double speed,
  ) {
    var nextY = enemy.center.dy + speed * dt;
    return enemy.copyWith(
      center: Offset(enemy.center.dx, nextY),
      direction: 1.0,
    );
  }

  static DynamicEnemy _spawnDynamicEnemy(Size viewport) {
    final viewportWidth = viewport.width;
    final enemyWidth = AppDimensions.enemySizeForSize(viewport);
    print(
      '[ENEMY SPAWN DEBUG] _spawnDynamicEnemy viewport.width: $viewportWidth, enemyWidth: $enemyWidth',
    );
    if (viewportWidth <= 0) {
      print('[ENEMY SPAWN DEBUG] viewport width is zero, skipping spawn');
      return DynamicEnemy(
        center: Offset.zero,
        path: EnemyPath.vertical,
        direction: 1.0,
      );
    }
    final minX = enemyWidth / 2;
    final maxX = viewportWidth - enemyWidth / 2;
    print('[ENEMY SPAWN DEBUG] minX: $minX, maxX: $maxX');

    final x = minX + _random.nextDouble() * (maxX - minX);

    final y = -(300 + _random.nextDouble() * 900);
    print('[ENEMY SPAWN DEBUG] spawnCoord: (${x.toDouble()}, ${y.toDouble()})');
    return DynamicEnemy(
      center: Offset(x.toDouble(), y.toDouble()),
      path: EnemyPath.vertical,
      direction: 1.0,
    );
  }

  LevelEnemyProgress progressDynamicEnemies({
    required int levelDifficulty,
    required int points,
    required int spawnedEnemyBatches,
    required List<DynamicEnemy> dynamicEnemies,
    required Size viewport,
    required double dt,
  }) {
    final filteredEnemies = dynamicEnemies
        .where((enemy) => enemy.center.dy < viewport.height + 100)
        .toList();

    final movedEnemies = filteredEnemies
        .map((enemy) {
          final speed = _dynamicEnemySpeed(levelDifficulty, points);
          return _moveDynamicEnemy(enemy, viewport, dt, speed);
        })
        .where((enemy) => enemy.center.dy < viewport.height + 100)
        .toList();

    return LevelEnemyProgress(
      spawnedEnemyBatches: spawnedEnemyBatches,
      dynamicEnemies: movedEnemies,
    );
  }

  LevelEnemyFrame advanceFrame({
    required LevelState state,
    required double dt,
    required Size viewport,
  }) {
    final enemySize = AppDimensions.enemySizeForSize(viewport);
    final enemyRects = [
      ...state.dynamicEnemies.map(
        (enemy) => Rect.fromCenter(
          center: enemy.center,
          width: enemySize,
          height: enemySize,
        ),
      ),
    ];
    return LevelEnemyFrame(enemyDirection: 1, enemyRects: enemyRects);
  }
}
