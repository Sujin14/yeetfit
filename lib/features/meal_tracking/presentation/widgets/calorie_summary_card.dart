import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/food_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Today's calories versus goal, colored by progress level.
class CalorieSummaryCard extends ConsumerWidget {
  final String userId;

  const CalorieSummaryCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final consumed = ref.watch(dailyNutrientsProvider(userId))['calories']!;
    final targetsAsync = ref.watch(nutritionTargetsProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: targetsAsync.when(
          loading: () => const SizedBox(
            height: 132,
            child: ShimmerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(height: 14, width: 120),
                  SizedBox(height: AppSpacing.smd),
                  ShimmerLine(height: 36, width: 180),
                  Spacer(),
                  ShimmerLine(height: 8),
                ],
              ),
            ),
          ),
          error: (_, _) => SizedBox(
            height: 132,
            child: YeetErrorState.compact(
              message: "Couldn't load your calorie goal.",
              onRetry: () => ref.invalidate(userDocumentProvider(userId)),
            ),
          ),
          data: (targets) {
            final goal = targets?.calories.toDouble() ?? 0;
            final remaining = goal - consumed;
            final level = ProgressLevel.fromRatio(
              goal > 0 ? consumed / goal : 0.0,
            );
            return Column(
              children: [
                Text(
                  consumed.round().toString(),
                  style: textTheme.displayLarge!.copyWith(
                    color: colors.onBackground,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  goal > 0 ? '/ ${goal.round()} kcal' : 'kcal',
                  style: textTheme.bodyLarge!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.smd),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal > 0 ? (consumed / goal).clamp(0.0, 1.0) : 0,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(
                      colors.progressColor(level),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  goal <= 0
                      ? 'Add your gender, age, height and weight in Settings '
                            'to get a daily calorie target'
                      : remaining >= 0
                      ? '${remaining.round()} kcal remaining'
                      : '${(-remaining).round()} kcal over goal',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
