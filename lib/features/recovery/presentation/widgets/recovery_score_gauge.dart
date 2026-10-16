import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'recovery_gauge_painter.dart';

/// 180×180 arc gauge with the score in the centre. Scale it with a
/// `FittedBox` for smaller placements.
class RecoveryScoreGauge extends StatelessWidget {
  static const double size = 180;

  final int score;

  const RecoveryScoreGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: score / 100),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, progress, child) => CustomPaint(
          painter: RecoveryGaugePainter(
            progress: progress,
            strokeWidth: 12,
            trackColor: Colors.white.withValues(alpha: 0.1),
            startColor: colors.secondary,
            endColor: colors.primary,
          ),
          child: child,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: textTheme.displayLarge!.copyWith(
                  color: colors.onBackground,
                ),
              ),
              Text(
                '/ 100',
                style: textTheme.bodySmall!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
