enum LevelType {
  desertStorm(
    menuKey: 'desertStormLevel',
    shipAsset: 'assets/images/ships/ship_1.png',
    fieldAsset: 'assets/images/fields/field_1.png',
    enemyTexture: 'assets/images/enemies/enemy_1.png',
    ammunitionAsset: 'assets/images/ammunition/ammunition_1.png',
    treeAsset: 'assets/images/trees/tree_1.png',
    city: 1,
    levelDifficulty: 1,
  ),
  operationDune(
    menuKey: 'operationDuneLevel',
    shipAsset: 'assets/images/ships/ship_2.png',
    fieldAsset: 'assets/images/fields/field_2.png',
    enemyTexture: 'assets/images/enemies/enemy_2.png',
    ammunitionAsset: 'assets/images/ammunition/ammunition_2.png',
    treeAsset: 'assets/images/trees/tree_2.png',
    city: 1,
    levelDifficulty: 2,
  ),
  operationVortex(
    menuKey: 'operationVortexLevel',
    shipAsset: 'assets/images/ships/ship_3.png',
    fieldAsset: 'assets/images/fields/field_3.png',
    enemyTexture: 'assets/images/enemies/enemy_3.png',
    ammunitionAsset: 'assets/images/ammunition/ammunition_3.png',
    treeAsset: 'assets/images/trees/tree_3.png',
    city: 2,
    levelDifficulty: 3,
  ),
  operationShield(
    menuKey: 'operationShieldLevel',
    shipAsset: 'assets/images/ships/ship_4.png',
    fieldAsset: 'assets/images/fields/field_4.png',
    enemyTexture: 'assets/images/enemies/enemy_4.png',
    ammunitionAsset: 'assets/images/ammunition/ammunition_4.png',
    treeAsset: 'assets/images/trees/tree_4.png',
    city: 2,
    levelDifficulty: 4,
  ),
  arabianNights(
    menuKey: 'arabianNightsLevel',
    shipAsset: 'assets/images/ships/ship_5.png',
    fieldAsset: 'assets/images/fields/field_5.png',
    enemyTexture: 'assets/images/enemies/enemy_5.png',
    ammunitionAsset: 'assets/images/ammunition/ammunition_5.png',
    treeAsset: 'assets/images/trees/tree_2.png',
    city: 1,
    levelDifficulty: 5,
  );

  const LevelType({
    required this.menuKey,
    required this.shipAsset,
    required this.fieldAsset,
    required this.enemyTexture,
    required this.ammunitionAsset,
    required this.treeAsset,
    required this.city,
    required this.levelDifficulty,
  });

  final String menuKey;
  final String shipAsset;
  final String fieldAsset;
  final String enemyTexture;
  final String ammunitionAsset;
  final String treeAsset;
  final int city;
  final int levelDifficulty;
}
