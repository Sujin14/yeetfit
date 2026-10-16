import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/count_up_builder.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/macro_progress_tile.dart';
import '../providers/daily_progress_provider.dart';
import 'dashboard_card_error.dart';
import 'dashboard_card_skeleton.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Calories and macro breakdown for the selected day.
class DashboardMealCard extends ConsumerWidget {
  final String userId;
  final VoidCallback onLogMeal;

  const DashboardMealCard({
    super.key,
    required this.userId,
    required this.onLogMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: progressAsync.when(
        loading: () => const DashboardCardSkeleton(height: 190),
        error: (error, _) => DashboardCardError(
          message: 'Could not load nutrition: $error',
          onRetry: () => ref.invalidate(dailyProgressStreamProvider(userId)),
        ),
        data: (progress) {
          final calories = progress.calories;
          final caloriesGoal = progress.caloriesGoal;
          final caloriesRatio = caloriesGoal > 0
              ? (calories / caloriesGoal).clamp(0.0, 1.0)
              : 0.0;

          return GlassCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            borderRadius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Today's Nutrition",
                        style: textTheme.titleMedium!.copyWith(
                          color: colors.onBackground,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onLogMeal,
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        'Log meal →',
                        style: textTheme.labelLarge!.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    CountUpBuilder(
                      value: calories.toDouble(),
                      builder: (context, shown) => Text(
                        '${shown.round()}',
                        style: textTheme.displayLarge!.copyWith(
                          color: colors.onBackground,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '/ ${caloriesGoal.round()} kcal',
                      style: textTheme.bodyMedium!.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: caloriesRatio,
                    minHeight: 6,
                    backgroundColor: colors.calories.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(colors.calories),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: MacroProgressTile(
                        label: 'Protein',
                        consumed: progress.protein,
                        goal: progress.proteinGoal,
                        unit: 'g',
                        color: colors.protein,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: MacroProgressTile(
                        label: 'Carbs',
                        consumed: progress.carbs,
                        goal: progress.carbsGoal,
                        unit: 'g',
                        color: colors.carbs,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: MacroProgressTile(
                        label: 'Fat',
                        consumed: progress.fat,
                        goal: progress.fatGoal,
                        unit: 'g',
                        color: colors.fat,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
