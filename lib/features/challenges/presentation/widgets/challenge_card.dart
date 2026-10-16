import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import '../../domain/entities/challenge.dart';
import '../providers/challenge_provider.dart';
import 'challenge_days_badge.dart';
import 'challenge_metric_icon.dart';
import 'challenge_progress_bar.dart';
import 'join_leave_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeCard extends ConsumerWidget {
  final Challenge challenge;
  final String userId;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final myProgressAsync = ref.watch(
      myProgressProvider((cId: challenge.id, uId: userId)),
    );
    final myProgress = myProgressAsync.value;
    final participants = challenge.participantCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 20,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ChallengeMetricIcon(metric: challenge.metric),
                      const Spacer(),
                      ChallengeDaysBadge(
                        daysRemaining: challenge.daysRemaining(DateTime.now()),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  Text(
                    challenge.title,
                    style: textTheme.titleMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  if (challenge.description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      challenge.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  if (myProgress != null) ...[
                    const SizedBox(height: AppSpacing.smd),
                    ChallengeProgressBar(
                      current: myProgress.currentProgress,
                      goal: challenge.goal,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.smd),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          participants == 1
                              ? '1 participant'
                              : '$participants participants',
                          style: textTheme.bodySmall!.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                      if (myProgressAsync.isLoading)
                        const ShimmerBox(
                          width: 96,
                          height: 36,
                          borderRadius: 18,
                        )
                      else
                        JoinLeaveButton(
                          challengeId: challenge.id,
                          userId: userId,
                          isJoined: myProgress != null,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
