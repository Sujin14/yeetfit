import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/progress_ring_painter.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Circular progress ring with the consumed/goal count in the centre.
class WaterCircularIndicator extends StatelessWidget {
  static const double size = 160;

  final int consumed;
  final int goal;
  final Color progressColor;

  const WaterCircularIndicator({
    super.key,
    required this.consumed,
    required this.goal,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final progress = goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0.0;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => CustomPaint(
                painter: ProgressRingPainter(
                  progress: value,
                  strokeWidth: 14,
                  color: progressColor,
                  trackColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, color: progressColor, size: 28),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$consumed / $goal',
                style: textTheme.headlineMedium!.copyWith(
                  color: colors.onBackground,
                ),
              ),
              Text(
                'glasses',
                style: textTheme.bodySmall!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
