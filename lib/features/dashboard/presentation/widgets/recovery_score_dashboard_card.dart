import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/recovery/domain/entities/recovery_score.dart';
import 'package:yeetfit/features/recovery/presentation/providers/recovery_provider.dart';
import 'package:yeetfit/features/recovery/presentation/widgets/recovery_analog_meter.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'dashboard_card_skeleton.dart';
import 'recovery_score_locked_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Today's recovery score on the dashboard; locked until enough tracking
/// history exists.
class RecoveryScoreDashboardCard extends ConsumerWidget {
  final String userId;
  final VoidCallback onOpenDetails;

  const RecoveryScoreDashboardCard({
    super.key,
    required this.userId,
    required this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(recoveryScoreProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: scoreAsync.when(
        loading: () => const DashboardCardSkeleton(height: 152),
        // An unreadable score is treated like a missing one.
        error: (_, _) => RecoveryScoreLockedCard(onTap: onOpenDetails),
        data: (score) => score == null
            ? RecoveryScoreLockedCard(onTap: onOpenDetails)
            : _buildScoreCard(context, score),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, RecoveryScore score) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenDetails,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: 20,
        child: Row(
          children: [
            RecoveryAnalogMeter(score: score.score),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.level.label,
                    style: textTheme.titleMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    score.recommendation.label,
                    style: textTheme.labelLarge!.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    score.recommendation.description,
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextButton(
                    onPressed: onOpenDetails,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      foregroundColor: colors.primary,
                    ),
                    child: Text(
                      'See breakdown →',
                      style: textTheme.labelLarge!.copyWith(
                        color: colors.primary,
                      ),
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
