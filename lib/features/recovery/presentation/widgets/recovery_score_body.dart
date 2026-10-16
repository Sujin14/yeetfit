import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/recovery_score.dart';
import 'recovery_breakdown_card.dart';
import 'recovery_recommendation_card.dart';
import 'recovery_score_gauge.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class RecoveryScoreBody extends StatelessWidget {
  final RecoveryScore score;
  final String userId;

  const RecoveryScoreBody({
    super.key,
    required this.score,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xl,
      ),
      children: [
        Center(child: RecoveryScoreGauge(score: score.score)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          score.level.label,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge!.copyWith(color: colors.onBackground),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          score.recommendation.label,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium!.copyWith(color: colors.onBackground),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          score.recommendation.description,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        RecoveryBreakdownCard(score: score, userId: userId),
        const SizedBox(height: AppSpacing.md),
        RecoveryRecommendationCard(score: score),
      ],
    );
  }
}
