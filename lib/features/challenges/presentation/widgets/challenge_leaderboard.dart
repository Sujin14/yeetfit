import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/challenge.dart';
import '../providers/challenge_provider.dart';
import '../utils/challenge_metric_style.dart';
import 'challenge_leaderboard_row.dart';
import 'challenge_section_card.dart';

class ChallengeLeaderboard extends ConsumerWidget {
  final Challenge challenge;
  final String userId;

  const ChallengeLeaderboard({
    super.key,
    required this.challenge,
    required this.userId,
  });

  // Participant docs only hold the uid; a short prefix keeps rows readable
  // without exposing profile data.
  static String _displayName(String uid) =>
      'Athlete ${uid.length > 6 ? uid.substring(0, 6) : uid}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final mutedStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary);
    final leaderboard = ref.watch(challengeLeaderboardProvider(challenge.id));

    return ChallengeSectionCard(
      title: 'Top 10',
      trailing: Icon(Icons.leaderboard_rounded, color: colors.warning),
      child: leaderboard.when(
        data: (participants) => participants.isEmpty
            ? Text('No participants yet. Be the first!', style: mutedStyle)
            : Column(
                children: [
                  for (final (index, participant) in participants.indexed)
                    ChallengeLeaderboardRow(
                      rank: index + 1,
                      name: participant.uid == userId
                          ? 'You'
                          : _displayName(participant.uid),
                      value:
                          '${formatChallengeValue(participant.currentProgress, challenge.metric)} '
                          '${challengeMetricUnit(challenge.metric)}',
                      isCurrentUser: participant.uid == userId,
                    ),
                ],
              ),
        loading: () => ShimmerWrapper(
          child: Column(
            children: [
              for (var i = 0; i < 4; i++)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: ShimmerLine(height: 20),
                ),
            ],
          ),
        ),
        error: (_, _) => YeetErrorState.compact(
          message: "Couldn't load the leaderboard.",
          onRetry: () =>
              ref.invalidate(challengeLeaderboardProvider(challenge.id)),
        ),
      ),
    );
  }
}
