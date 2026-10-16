import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/workout_log_provider.dart';
import '../utils/workout_summary.dart';
import 'log_workout_sheet.dart';

/// Opens the log-workout sheet; shows today's workout once logged.
class LogWorkoutButton extends ConsumerWidget {
  final String userId;

  const LogWorkoutButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final status = ref.watch(todayWorkoutStatusProvider(userId)).value;
    final log = status?.log;

    final subtitle = switch (status) {
      null => '',
      _ when log != null => workoutSummary(log, planTitle: status.logPlanTitle),
      _ => "Tap to log today's workout",
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => LogWorkoutSheet.show(context, userId: userId),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.fitness_center, color: colors.primary, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's workout",
                    style: textTheme.titleMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall!.copyWith(
                      color: log == null
                          ? colors.textMuted
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              log == null ? Icons.add_circle_outline : Icons.edit_outlined,
              color: colors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
