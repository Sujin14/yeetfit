import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/workout_log/domain/entities/today_workout_status.dart';
import 'package:yeetfit/features/workout_log/presentation/providers/workout_log_provider.dart';
import 'package:yeetfit/features/workout_log/presentation/utils/workout_summary.dart';
import 'package:yeetfit/features/workout_log/presentation/widgets/log_workout_sheet.dart';
import '../../domain/entities/recovery_score.dart';
import '../../domain/usecases/workout_recovery_points.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Workout entry in the recovery breakdown; tapping always opens the
/// log-workout sheet.
class RecoveryWorkoutRow extends ConsumerWidget {
  final String userId;

  const RecoveryWorkoutRow({super.key, required this.userId});

  static String _message(TodayWorkoutStatus? status) {
    final log = status?.log;
    final plan = status?.plan;
    if (log != null) {
      final points = workoutRecoveryPoints(log).round();
      final maxPoints = RecoveryScore.maxWorkout.round();
      final summary = workoutSummary(log, planTitle: status!.logPlanTitle);
      return '$summary → $points/$maxPoints pts${log.fromPlan ? ' ✓' : ''}';
    }
    if (plan != null) {
      return '📋 ${plan.title} assigned — Tap to log completion';
    }
    return 'Not logged today — tap to log';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final status = ref.watch(todayWorkoutStatusProvider(userId)).value;
    final isLogged = status?.isLogged ?? false;
    final hasPendingPlan = status?.hasPendingPlan ?? false;

    final borderColor = hasPendingPlan
        ? colors.secondary
        : Colors.white.withValues(alpha: 0.12);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => LogWorkoutSheet.show(context, userId: userId),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd,
            vertical: AppSpacing.smd,
          ),
          decoration: BoxDecoration(
            color: hasPendingPlan
                ? colors.secondary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: hasPendingPlan ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department_outlined,
                color: colors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workout',
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status == null ? '' : _message(status),
                      style: textTheme.bodySmall!.copyWith(
                        color: isLogged || hasPendingPlan
                            ? colors.textSecondary
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isLogged ? Icons.edit_outlined : Icons.add_circle_outline,
                color: hasPendingPlan ? colors.secondary : colors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
