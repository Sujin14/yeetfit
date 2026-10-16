import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/steps_data.dart';
import '../providers/steps_provider.dart';
import 'step_hero_stat.dart';
import 'steps_health_access_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Today's step count, goal progress, calories burned and distance.
class StepHeroSection extends ConsumerWidget {
  final String userId;

  const StepHeroSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final stepsAsync = ref.watch(stepsCountProvider(userId));
    final goalSteps = ref.watch(
      stepsGoalProvider(
        userId,
      ).select((value) => value.value ?? defaultStepsGoal),
    );
    final numberFormat = NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: switch (stepsAsync) {
        AsyncData(value: null) => StepsHealthAccessCard(
          onEnable: () =>
              ref.read(stepsCountProvider(userId).notifier).requestAccess(),
        ),
        AsyncData(value: final int steps) => GlassCard(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  numberFormat.format(steps),
                  style: textTheme.displayLarge!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
              ),
              Text(
                '/ ${numberFormat.format(goalSteps)} steps goal',
                style: textTheme.bodyLarge!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(
                value: goalSteps > 0 ? (steps / goalSteps).clamp(0.0, 1.0) : 0,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                color: colors.progressColor(
                  ProgressLevel.fromRatio(
                    goalSteps > 0 ? steps / goalSteps : 0,
                  ),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StepHeroStat(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: colors.calories,
                      value:
                          '${StepsData.caloriesFor(steps).toStringAsFixed(0)} kcal',
                      label: 'Burned today',
                    ),
                  ),
                  Expanded(
                    child: StepHeroStat(
                      icon: Icons.route_rounded,
                      iconColor: colors.secondary,
                      value:
                          '${StepsData.distanceKmFor(steps).toStringAsFixed(2)} km',
                      label: 'Distance',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AsyncError(:final error) => GlassCard(
          padding: EdgeInsets.zero,
          child: YeetErrorState.compact(
            message: 'Could not read steps: $error',
            onRetry: () => ref.invalidate(stepsCountProvider(userId)),
          ),
        ),
        _ => const ShimmerCard(height: 200, margin: EdgeInsets.zero),
      },
    );
  }
}
