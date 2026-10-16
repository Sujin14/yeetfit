import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/recovery_score.dart';
import 'recovery_metric_row.dart';
import 'recovery_workout_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class RecoveryBreakdownCard extends StatelessWidget {
  final RecoveryScore score;
  final String userId;

  const RecoveryBreakdownCard({
    super.key,
    required this.score,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakdown',
            style: textTheme.titleLarge!.copyWith(color: colors.onBackground),
          ),
          const SizedBox(height: AppSpacing.md),
          RecoveryMetricRow(
            icon: Icons.bedtime_outlined,
            label: 'Sleep',
            value: score.sleepContrib,
            max: score.maxSleep,
          ),
          const SizedBox(height: AppSpacing.md),
          RecoveryMetricRow(
            icon: Icons.water_drop_outlined,
            label: 'Water',
            value: score.waterContrib,
            max: score.maxWater,
          ),
          const SizedBox(height: AppSpacing.md),
          if (score.stepsTracked)
            RecoveryMetricRow(
              icon: Icons.directions_walk,
              label: 'Steps',
              value: score.stepsContrib,
              max: score.maxSteps,
            )
          else
            Text(
              'No step data today — its '
              '${RecoveryScore.stepsPoints.round()} pts are split between '
              'sleep and water.',
              style: textTheme.bodySmall!.copyWith(color: colors.textMuted),
            ),
          const SizedBox(height: AppSpacing.md),
          RecoveryWorkoutRow(userId: userId),
        ],
      ),
    );
  }
}
