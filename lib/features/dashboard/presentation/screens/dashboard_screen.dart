import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/challenge_route_constants.dart';
import 'package:yeetfit/core/routes/chat_route_constants.dart';
import 'package:yeetfit/core/routes/recovery_route_constants.dart';
import 'package:yeetfit/core/routes/settings_route_constants.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_trigger.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/shared/widgets/glass_bottom_nav_bar.dart';
import 'package:yeetfit/features/mood/presentation/widgets/mood_log_row.dart';
import 'package:yeetfit/features/recovery/domain/entities/recovery_score.dart';
import 'package:yeetfit/features/recovery/presentation/providers/recovery_provider.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/staggered_entrance.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../widgets/daily_progress_grid.dart';
import '../widgets/dashboard_bmi_card.dart';
import '../widgets/dashboard_challenges_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_meal_card.dart';
import '../widgets/dashboard_shimmer.dart';
import '../widgets/dashboard_workout_card.dart';
import '../widgets/recovery_score_dashboard_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: SignInRequiredView(message: 'Please log in to view dashboard'),
      );
    }

    // Keeps today's recovery calculation running. It re-runs when water,
    // sleep, steps or the workout change, and the card shows the saved result.
    ref.listen(calculateRecoveryProvider(userId), (_, result) {
      final error = result.error;
      if (error != null && error is! RecoveryScoreLockedException) {
        debugPrint('Recovery score calculation failed: $error');
      }
    });

    // Cards load independently; the profile gates the first paint so the
    // header never flashes empty. With Firestore persistence this resolves
    // from cache almost immediately, including offline.
    final profile = ref.watch(userDocumentProvider(userId));
    if (!profile.hasValue) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: profile.hasError
              ? YeetErrorState(
                  message: 'Could not load your dashboard.',
                  onRetry: () => ref.invalidate(userDocumentProvider(userId)),
                )
              : const DashboardShimmer(),
        ),
      );
    }

    return WalkthroughTrigger(
      tourKey: WalkthroughController.dashboard,
      userId: userId,
      targets: DashboardTour.targets,
      introMessage: DashboardTour.introMessage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            // Showcase targets must be built to be found and scrolled to;
            // this keeps every toured card alive below the fold.
            cacheExtent: 1500,
            slivers: [
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 0,
                  child: DashboardHeader(
                    onOpenChatbot: () =>
                        context.push(ChatRouteConstants.chatbot),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 1,
                  child: YanaShowcase(
                    step: DashboardTour.recovery,
                    child: RecoveryScoreDashboardCard(
                      userId: userId,
                      onOpenDetails: () =>
                          context.push(RecoveryRouteConstants.root),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 2,
                  child: YanaShowcase(
                    step: DashboardTour.mood,
                    child: MoodLogRow(userId: userId),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 3,
                  child: YanaShowcase(
                    step: DashboardTour.progressGrid,
                    child: DailyProgressGrid(
                      userId: userId,
                      onOpenTracker: (route) => context.push(route),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 4,
                  child: DashboardWorkoutCard(userId: userId),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 5,
                  child: YanaShowcase(
                    step: DashboardTour.mealCard,
                    child: DashboardMealCard(
                      userId: userId,
                      onLogMeal: () =>
                          context.push(TrackingRouteConstants.calorieTracking),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 6,
                  child: DashboardBmiCard(
                    userId: userId,
                    onCompleteProfile: () =>
                        context.push(SettingsRouteConstants.basicInformation),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              SliverToBoxAdapter(
                child: StaggeredEntrance(
                  index: 7,
                  child: DashboardChallengesCard(
                    onOpen: () => context.push(ChallengeRouteConstants.root),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: GlassBottomNavBar.contentClearance + 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
