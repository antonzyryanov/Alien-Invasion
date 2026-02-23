part of 'level_bloc.dart';

class LevelState extends Equatable {
  const LevelState({
    required this.status,
    required this.levelType,
    required this.playerName,
    required this.viewport,
    required this.shipCenter,
    required this.shipVelocity,
    required this.enemyDirection,
    required this.points,
    required this.spawnedEnemyBatches,
    required this.dynamicEnemies,
    required this.dynamicClouds,
    required this.dynamicTrees,
    required this.dynamicHouses,
    required this.lives,
    required this.timeLeft,
    required this.totalDuration,
    required this.elapsed,
    required this.errorMessage,
    required this.finishedAt,
    required this.dynamicAmmunition,
    required this.cloudTimers,
    required this.treeTimers,
    required this.houseTimers,
    required this.enemyTimers,
    required this.enemySpawnTimer,
  });

  factory LevelState.initial() => LevelState(
    status: LevelStatus.idle,
    levelType: null,
    playerName: '',
    viewport: Size.zero,
    shipCenter: Offset.zero,
    shipVelocity: const Offset(120, -150),
    enemyDirection: 1,
    points: 0,
    spawnedEnemyBatches: 0,
    dynamicEnemies: const [],
    dynamicClouds: const [],
    dynamicTrees: const [],
    dynamicHouses: const [],
    dynamicAmmunition: const [],
    lives: 3,
    timeLeft: Duration.zero,
    totalDuration: Duration.zero,
    elapsed: Duration.zero,
    errorMessage: null,
    finishedAt: null,
    cloudTimers: const {},
    treeTimers: const {},
    houseTimers: const {},
    enemyTimers: const {},
    enemySpawnTimer: 0.0,
  );
  final double enemySpawnTimer;

  final LevelStatus status;
  final LevelType? levelType;
  final String playerName;
  final Size viewport;
  final Offset shipCenter;
  final Offset shipVelocity;
  final double enemyDirection;
  final int points;
  final int spawnedEnemyBatches;
  final List<DynamicEnemy> dynamicEnemies;
  final List<DynamicCloud> dynamicClouds;
  final List<DynamicTree> dynamicTrees;
  final List<DynamicHouse> dynamicHouses;
  final List<DynamicAmmunition> dynamicAmmunition;
  final int lives;
  final Duration timeLeft;
  final Duration totalDuration;
  final Duration elapsed;
  final String? errorMessage;
  final DateTime? finishedAt;
  final Map<String, double> cloudTimers;
  final Map<String, double> treeTimers;
  final Map<String, double> houseTimers;
  final Map<String, double> enemyTimers;

  bool get isPlayable => status == LevelStatus.playing;

  LevelState copyWith({
    LevelStatus? status,
    LevelType? levelType,
    String? playerName,
    Size? viewport,
    Offset? shipCenter,
    Offset? shipVelocity,
    double? enemyDirection,
    int? points,
    int? spawnedEnemyBatches,
    List<DynamicEnemy>? dynamicEnemies,
    List<DynamicCloud>? dynamicClouds,
    List<DynamicTree>? dynamicTrees,
    List<DynamicHouse>? dynamicHouses,
    List<DynamicAmmunition>? dynamicAmmunition,
    int? lives,
    Duration? timeLeft,
    Duration? totalDuration,
    Duration? elapsed,
    String? errorMessage,
    DateTime? finishedAt,
    Map<String, double>? cloudTimers,
    Map<String, double>? treeTimers,
    Map<String, double>? houseTimers,
    Map<String, double>? enemyTimers,
    double? enemySpawnTimer,
  }) {
    return LevelState(
      status: status ?? this.status,
      levelType: levelType ?? this.levelType,
      playerName: playerName ?? this.playerName,
      viewport: viewport ?? this.viewport,
      shipCenter: shipCenter ?? this.shipCenter,
      shipVelocity: shipVelocity ?? this.shipVelocity,
      enemyDirection: enemyDirection ?? this.enemyDirection,
      points: points ?? this.points,
      spawnedEnemyBatches: spawnedEnemyBatches ?? this.spawnedEnemyBatches,
      dynamicEnemies: dynamicEnemies ?? this.dynamicEnemies,
      dynamicClouds: dynamicClouds ?? this.dynamicClouds,
      dynamicTrees: dynamicTrees ?? this.dynamicTrees,
      dynamicHouses: dynamicHouses ?? this.dynamicHouses,
      dynamicAmmunition: dynamicAmmunition ?? this.dynamicAmmunition,
      lives: lives ?? this.lives,
      timeLeft: timeLeft ?? this.timeLeft,
      totalDuration: totalDuration ?? this.totalDuration,
      elapsed: elapsed ?? this.elapsed,
      errorMessage: errorMessage,
      finishedAt: finishedAt ?? this.finishedAt,
      cloudTimers: Map<String, double>.from(cloudTimers ?? this.cloudTimers),
      treeTimers: Map<String, double>.from(treeTimers ?? this.treeTimers),
      houseTimers: Map<String, double>.from(houseTimers ?? this.houseTimers),
      enemyTimers: Map<String, double>.from(enemyTimers ?? this.enemyTimers),
      enemySpawnTimer: enemySpawnTimer ?? this.enemySpawnTimer,
    );
  }

  @override
  List<Object?> get props => [
    status,
    levelType,
    playerName,
    viewport,
    shipCenter,
    shipVelocity,
    enemyDirection,
    points,
    spawnedEnemyBatches,
    dynamicEnemies,
    dynamicClouds,
    dynamicTrees,
    dynamicHouses,
    dynamicAmmunition,
    lives,
    timeLeft,
    totalDuration,
    elapsed,
    errorMessage,
    finishedAt,
    cloudTimers,
    treeTimers,
    houseTimers,
    enemyTimers,
  ];
}
