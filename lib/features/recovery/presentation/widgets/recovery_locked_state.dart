import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/recovery_score.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Shown on the detail screen until today's score exists.
class RecoveryLockedState extends StatelessWidget {
  /// Shown below the message, e.g. a way to start tracking.
  final Widget? action;

  const RecoveryLockedState({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: colors.textMuted, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Recovery Score is locked',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Log sleep, water, steps or a workout on '
              '${RecoveryScoreLockedException.requiredTrackedDays} days '
              'to unlock',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
