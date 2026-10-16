import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_trigger.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/challenge.dart';
import 'challenge_card.dart';
import 'challenges_message_card.dart';
import 'challenges_shimmer.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeListSliver extends StatelessWidget {
  final AsyncValue<List<Challenge>> challenges;
  final String userId;
  final ValueChanged<Challenge> onOpen;
  final VoidCallback onRetry;

  const ChallengeListSliver({
    super.key,
    required this.challenges,
    required this.userId,
    required this.onOpen,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return challenges.when(
      data: (items) => items.isEmpty
          ? const SliverToBoxAdapter(
              child: ChallengesMessageCard(
                imageAsset: 'assets/images/empty_challenges.webp',
                message: 'No active challenges right now. Check back soon!',
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final card = ChallengeCard(
                    challenge: items[index],
                    userId: userId,
                    onTap: () => onOpen(items[index]),
                  );
                  if (index != 0) return card;
                  // Only the first card is toured, and an empty list never
                  // builds it, so the tour can't start without a target.
                  return WalkthroughTrigger(
                    tourKey: WalkthroughController.challenges,
                    userId: userId,
                    targets: ChallengesTour.targets,
                    child: YanaShowcase(
                      step: ChallengesTour.firstCard,
                      child: card,
                    ),
                  );
                },
              ),
            ),
      loading: () => const SliverToBoxAdapter(child: ChallengesShimmer()),
      error: (_, _) => SliverToBoxAdapter(
        child: YeetErrorState(
          message: "Couldn't load challenges.",
          onRetry: onRetry,
        ),
      ),
    );
  }
}
