part of '../level_bloc.dart';

class _LevelShipLogic {
  static const Offset initialVelocity = Offset(360, -450);

  LevelShipFrame advanceFrame({
    required LevelState state,
    required double dt,
    required double tiltX,
    required double tiltY,
    required Size viewport,
    required List<Rect> enemyRects,
  }) {
    final double shipY = viewport.height - 80;
    final Offset velocity = Offset(tiltX * 30, 0) * dt;
    double nextDx = state.shipCenter.dx + velocity.dx;

    if (state.shipCenter == Offset.zero) {
      nextDx = viewport.width / 2;
    }
    final double clampedDx = nextDx.clamp(0.0, viewport.width);
    final Offset clampedCenter = Offset(clampedDx, shipY);

    bool hitEnemy = false;
    for (final enemyRect in enemyRects) {
      if (enemyRect.contains(clampedCenter)) {
        hitEnemy = true;
        break;
      }
    }

    return LevelShipFrame(
      shipCenter: clampedCenter,
      shipVelocity: Offset(velocity.dx, 0),
      hitEnemy: hitEnemy,
    );
  }
}
