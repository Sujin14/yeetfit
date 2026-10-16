import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/weight_provider.dart';
import 'weight_goal_dialog.dart';
import 'weight_milestone.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Start → current → goal weights with a progress bar and goal editing.
class WeightProgressCard extends ConsumerWidget {
  final String userId;

  const WeightProgressCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final goal = ref.watch(weightGoalProvider(userId)).value;
    final currentWeight = ref.watch(currentWeightProvider(userId)).value;
    final weightProgress = ref.watch(weightProgressProvider(userId));
    final progressColor = colors.progressColor(weightProgress.level);
    final targetDate =
        goal?.targetDate ?? DateTime.now().add(const Duration(days: 180));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.cardPadding,
          AppSpacing.smd,
          AppSpacing.sm,
          AppSpacing.cardPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress to goal',
                        style: textTheme.titleMedium!.copyWith(
                          color: colors.onBackground,
                        ),
                      ),
                      Text(
                        'Target by ${DateFormat.yMMMd().format(targetDate)}',
                        style: textTheme.bodySmall!.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
                  tooltip: 'Edit goal',
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => WeightGoalDialog(userId: userId),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.smd),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: WeightMilestone(
                          label: 'Start',
                          weight: goal?.initialWeight,
                          valueColor: colors.onBackground,
                        ),
                      ),
                      Expanded(
                        child: WeightMilestone(
                          label: 'Current',
                          weight: currentWeight,
                          valueColor: progressColor,
                          alignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Expanded(
                        child: WeightMilestone(
                          label: 'Goal',
                          weight: goal?.goalWeight,
                          valueColor: colors.secondary,
                          alignment: CrossAxisAlignment.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  TweenAnimationBuilder<Color?>(
                    tween: ColorTween(
                      begin: colors.textMuted,
                      end: progressColor,
                    ),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, color, _) => LinearProgressIndicator(
                      value: weightProgress.progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: color,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
