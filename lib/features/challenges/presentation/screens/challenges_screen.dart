import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:yeetfit/core/routes/challenge_route_constants.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_list_sliver.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    final challenges = ref.watch(activeChallengesProvider);

    // Pushed above the shell, so it hosts its own tour.
    return ShowCaseWidget(
      enableAutoScroll: true,
      onFinish: WalkthroughController.finishActive,
      builder: (context) => ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: userId == null
              ? const SignInRequiredView(
                  message: 'Please log in to join challenges',
                )
              : CustomScrollView(
                  slivers: [
                    const GlassSliverAppBar(title: 'Community Challenges'),
                    ChallengeListSliver(
                      challenges: challenges,
                      userId: userId,
                      onOpen: (challenge) => context.push(
                        ChallengeRouteConstants.detail,
                        extra: challenge,
                      ),
                      onRetry: () => ref.invalidate(activeChallengesProvider),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xl),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
