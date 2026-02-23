import 'package:alien_invasion/app/bloc/level_bloc/models/dynamic_enemy.dart';

class LevelEnemyProgress {
  const LevelEnemyProgress({
    required this.spawnedEnemyBatches,
    required this.dynamicEnemies,
  });

  final int spawnedEnemyBatches;
  final List<DynamicEnemy> dynamicEnemies;
}
