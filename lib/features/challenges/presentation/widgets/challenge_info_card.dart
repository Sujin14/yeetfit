import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/challenge.dart';
import '../utils/challenge_metric_style.dart';
import 'challenge_days_badge.dart';
import 'challenge_metric_icon.dart';
import 'challenge_section_card.dart';
import 'challenge_stat_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeInfoCard extends StatelessWidget {
  final Challenge challenge;

  const ChallengeInfoCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final metric = challenge.metric;

    return ChallengeSectionCard(
      title: 'About this challenge',
      trailing: ChallengeDaysBadge(
        daysRemaining: challenge.daysRemaining(DateTime.now()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (challenge.description.isNotEmpty) ...[
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.smd),
          ],
          Row(
            children: [
              ChallengeMetricIcon(metric: metric, size: 32),
              const SizedBox(width: 10),
              Text(
                challengeMetricLabel(metric),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: colors.onBackground),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ChallengeStatRow(
            label: 'Goal',
            value:
                '${formatChallengeValue(challenge.goal, metric)} '
                '${challengeMetricUnit(metric)}',
          ),
          ChallengeStatRow(
            label: 'Duration',
            value: challenge.durationDays == 1
                ? '1 day'
                : '${challenge.durationDays} days',
          ),
          ChallengeStatRow(
            label: 'Participants',
            value: '${challenge.participantCount}',
          ),
        ],
      ),
    );
  }
}
