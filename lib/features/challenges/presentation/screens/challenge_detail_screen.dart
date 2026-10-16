import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../../domain/entities/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_info_card.dart';
import '../widgets/challenge_leaderboard.dart';
import '../widgets/challenge_my_progress_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    // Prefer the live copy so participantCount reflects joins and leaves.
    final current =
        ref
            .watch(activeChallengesProvider)
            .value
            ?.where((item) => item.id == challenge.id)
            .firstOrNull ??
        challenge;

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to view this challenge',
              )
            : CustomScrollView(
                slivers: [
                  GlassSliverAppBar(title: current.title),
                  SliverToBoxAdapter(
                    child: ChallengeInfoCard(challenge: current),
                  ),
                  SliverToBoxAdapter(
                    child: ChallengeMyProgressCard(
                      challenge: current,
                      userId: userId,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ChallengeLeaderboard(
                      challenge: current,
                      userId: userId,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
              ),
      ),
    );
  }
}
