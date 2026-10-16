import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/sleep_provider.dart';
import 'sleep_goal_dialog.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Section for sleep progress and goal editing.
class SleepProgressSection extends ConsumerWidget {
  final String userId;

  const SleepProgressSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final sleep = ref.watch(todaySleepProvider(userId)).value;
    final duration = sleep?.duration ?? 0.0;
    final goalHours = sleep?.goalHours ?? 8.0;
    final progressColor = colors.progressColor(
      ProgressLevel.fromRatio(goalHours > 0 ? duration / goalHours : 0),
    );

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
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${duration.toStringAsFixed(1)}h',
                          style: textTheme.titleLarge!.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                        TextSpan(
                          text: ' of ${goalHours.toStringAsFixed(1)}h goal',
                          style: textTheme.bodyMedium!.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SleepGoalDialog(userId: userId),
                  ),
                  tooltip: 'Set Sleep Goal',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.smd),
              child: TweenAnimationBuilder(
                tween: ColorTween(begin: colors.textMuted, end: progressColor),
                duration: const Duration(milliseconds: 300),
                builder: (context, color, child) => LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(4),
                  value: goalHours > 0
                      ? (duration / goalHours).clamp(0.0, 1.0)
                      : 0.0,
                  minHeight: 8,
                  color: color,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
