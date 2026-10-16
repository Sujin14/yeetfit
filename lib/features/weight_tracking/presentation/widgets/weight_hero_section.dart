import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../providers/weight_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WeightHeroSection extends ConsumerWidget {
  final String userId;

  const WeightHeroSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final currentWeight = ref.watch(currentWeightProvider(userId)).value;
    final goalWeight = ref.watch(
      weightGoalProvider(userId).select((value) => value.value?.goalWeight),
    );
    final weightProgress = ref.watch(weightProgressProvider(userId));
    final remaining = currentWeight != null && goalWeight != null
        ? (currentWeight - goalWeight).abs()
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Lottie.asset(
              'assets/animations/weight.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currentWeight?.toStringAsFixed(1) ?? '--',
                style: textTheme.displayLarge!.copyWith(
                  color: colors.onBackground,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'kg',
                style: textTheme.headlineMedium!.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            remaining == null
                ? 'Set a goal to track progress'
                : remaining < 0.1
                ? 'Goal reached! 🎉'
                : '${(weightProgress.progress * 100).toStringAsFixed(0)}% '
                      'to goal · ${remaining.toStringAsFixed(1)} kg to go',
            style: textTheme.bodyMedium!.copyWith(
              color: colors.progressColor(weightProgress.level),
            ),
          ),
        ],
      ),
    );
  }
}
