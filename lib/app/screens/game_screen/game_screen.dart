import 'package:alien_invasion/app/bloc/level_bloc/models/level_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alien_invasion/app/bloc/level_bloc/level_bloc.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_layout.dart';
import '../../../app_design/app_text_styles.dart';
import '../../../localizations/app_localizations.dart';
import 'widgets/ship_widget.dart';
import 'widgets/game_hud_layer.dart';
import 'widgets/game_over_showing_overlay.dart';
import 'widgets/game_enemies_layer.dart';
import 'widgets/level_finished_overlay.dart';
import 'widgets/game_city_layer.dart';
import 'widgets/game_trees_layer.dart';
import 'widgets/game_clouds_layer.dart';
import 'widgets/game_ammunition_layer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.levelBloc,
    required this.onBackToMenu,
    super.key,
  });

  final LevelBloc levelBloc;
  final VoidCallback onBackToMenu;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mqWidth = MediaQuery.of(context).size.width;
      print(
        '[DEBUG] state.viewport.width: '
        '${levelBloc.state.viewport.width}, MediaQuery width: $mqWidth',
      );
    });

    return BlocProvider.value(
      value: levelBloc,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final forcedViewport =
                (constraints.maxWidth == 0 || constraints.maxHeight == 0)
                ? MediaQuery.of(context).size
                : Size(constraints.maxWidth, constraints.maxHeight);
            levelBloc.add(LevelViewportChanged(forcedViewport));

            return BlocBuilder<LevelBloc, LevelState>(
              builder: (context, state) {
                final level = state.levelType;
                if (level == null) {
                  return const SizedBox.shrink();
                }

                final hudTopInset = AppLayout.hudTopInset(context);
                final hudEdgeInset = AppLayout.hudEdgeInset(context);
                final gameOverSize = AppLayout.gameOverSize(context);
                final bottomActionInset = AppLayout.bottomActionInset(context);

                final size = state.viewport;
                final layoutSize = size == Size.zero ? forcedViewport : size;
                final borderThickness = AppDimensions.borderThicknessForSize(
                  layoutSize,
                );
                final enemySize = AppDimensions.enemySizeForSize(layoutSize);
                final shipSize = AppDimensions.shipSizeForSize(layoutSize);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.read<LevelBloc>().add(const LevelAmmunitionFired());
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          level.fieldAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const ColoredBox(color: Colors.black54),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.black,
                                width: borderThickness,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GameCityLayer(
                        houses: state.dynamicHouses,
                        viewport: layoutSize,
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                      GameTreesLayer(
                        trees: state.dynamicTrees,
                        viewport: layoutSize,
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                      GameCloudsLayer(
                        clouds: state.dynamicClouds,
                        viewport: layoutSize,
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                      GameEnemiesLayer(
                        enemyTexture: level.enemyTexture,
                        borderThickness: borderThickness,
                        enemySize: enemySize,
                        dynamicEnemies: state.dynamicEnemies,
                      ),
                      GameAmmunitionLayer(
                        ammunition: state.dynamicAmmunition,
                        viewport: layoutSize,
                        ammunitionAsset: level.ammunitionAsset,
                      ),
                      ShipWidget(
                        shipCenter: state.shipCenter,
                        shipSize: shipSize,
                        shipAsset: level.shipAsset,
                      ),
                      GameHudLayer(
                        hudTopInset: hudTopInset,
                        hudEdgeInset: hudEdgeInset,
                        livesLabel: localizations.t('lives'),
                        pointsLabel: localizations.t('points'),
                        timeLabel: localizations.t('time'),
                        lives: state.lives,
                        points: state.points,
                        elapsed: state.elapsed,
                      ),
                      if (state.status == LevelStatus.gameOverShowing)
                        GameOverShowingOverlay(
                          gameOverSize: gameOverSize,
                          gameOverText: localizations.t('gameOver'),
                          gameOverTextStyle: AppTextStyles.title(context),
                        ),
                      if (state.status == LevelStatus.finished)
                        LevelFinishedOverlay(
                          points: state.points,
                          scoreLabel: localizations.t('scoreValue'),
                          backLabel: localizations.t('backToMainMenu'),
                          scoreTextStyle: AppTextStyles.scoreLarge(context),
                          bottomActionInset: bottomActionInset,
                          buttonHeight: AppDimensions.buttonHeight(context),
                          onBackToMenu: onBackToMenu,
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
