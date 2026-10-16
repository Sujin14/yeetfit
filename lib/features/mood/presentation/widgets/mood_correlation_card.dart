import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/mood_fitness_correlation.dart';
import 'mood_correlation_line_chart.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Chart plus a one-line insight derived from the Pearson correlation.
class MoodCorrelationCard extends StatelessWidget {
  static const double height = 280;
  static const double _threshold = 0.3;

  final MoodFitnessCorrelation correlation;

  const MoodCorrelationCard({super.key, required this.correlation});

  static String insightFor(double? r) {
    if (r != null && r > _threshold) {
      return 'On active days, your mood is higher 📈';
    }
    if (r != null && r < -_threshold) {
      return 'Rest days seem to lift your mood 😌';
    }
    return 'Keep logging to discover your pattern';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Mood × Fitness',
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.smd),
            Expanded(child: MoodCorrelationLineChart(days: correlation.days)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              insightFor(correlation.pearson),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
