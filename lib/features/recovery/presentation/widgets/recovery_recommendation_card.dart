import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/recovery_score.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Points to the metric with the most points still available today.
class RecoveryRecommendationCard extends StatelessWidget {
  final RecoveryScore score;

  const RecoveryRecommendationCard({super.key, required this.score});

  static (IconData, String) _biggestGap(RecoveryScore score) {
    final gaps = [
      (
        score.maxSleep - score.sleepContrib,
        Icons.bedtime_outlined,
        'Sleep is your biggest gap. Getting closer to your sleep goal tonight '
            'lifts tomorrow\'s score the most.',
      ),
      (
        score.maxWater - score.waterContrib,
        Icons.water_drop_outlined,
        'Hydration is holding you back. A few more glasses of water will '
            'close the gap.',
      ),
      (
        score.maxSteps - score.stepsContrib,
        Icons.directions_walk,
        'You\'re short on steps. A brisk walk is the easiest win today.',
      ),
      (
        RecoveryScore.maxWorkout - score.workoutContrib,
        Icons.local_fire_department_outlined,
        'Log today\'s workout to earn your activity points.',
      ),
    ]..sort((a, b) => b.$1.compareTo(a.$1));

    final (gap, icon, message) = gaps.first;
    if (gap < 0.5) {
      return (
        Icons.emoji_events_outlined,
        'Every metric is maxed out today. Great work — keep it up.',
      );
    }
    return (icon, message);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final (icon, message) = _biggestGap(score);

    return GlassCard(
      borderRadius: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to improve',
                  style: textTheme.titleMedium!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: textTheme.bodySmall!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
