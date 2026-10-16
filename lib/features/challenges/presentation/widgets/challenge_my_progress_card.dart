import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import '../../domain/entities/challenge.dart';
import '../providers/challenge_provider.dart';
import '../utils/challenge_metric_style.dart';
import 'challenge_completed_badge.dart';
import 'challenge_progress_bar.dart';
import 'challenge_section_card.dart';
import 'join_leave_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeMyProgressCard extends ConsumerWidget {
  final Challenge challenge;
  final String userId;

  const ChallengeMyProgressCard({
    super.key,
    required this.challenge,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final progressAsync = ref.watch(
      myProgressProvider((cId: challenge.id, uId: userId)),
    );
    final myProgress = progressAsync.value;
    final metric = challenge.metric;
    final unit = challengeMetricUnit(metric);

    return ChallengeSectionCard(
      title: 'My progress',
      trailing: myProgress?.completed == true
          ? const ChallengeCompletedBadge()
          : null,
      child: progressAsync.isLoading
          ? const ShimmerWrapper(
              child: ShimmerLine(height: 36, borderRadius: 18),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (myProgress == null)
                  Text(
                    'Join to start tracking your progress on the leaderboard.',
                    style: textTheme.bodyMedium!.copyWith(
                      color: colors.textSecondary,
                    ),
                  )
                else ...[
                  Text(
                    '${formatChallengeValue(myProgress.currentProgress, metric)}'
                    ' / ${formatChallengeValue(challenge.goal, metric)} $unit',
                    style: textTheme.titleLarge!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ChallengeProgressBar(
                    current: myProgress.currentProgress,
                    goal: challenge.goal,
                    height: 8,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: JoinLeaveButton(
                    challengeId: challenge.id,
                    userId: userId,
                    isJoined: myProgress != null,
                    width: 120,
                    height: 40,
                  ),
                ),
              ],
            ),
    );
  }
}
