import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yeetfit/core/routes/plans_route_constants.dart';
import 'package:yeetfit/core/routes/session_route_constants.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_trigger.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/features/coaches/presentation/providers/coach_provider.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_detail_controller.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_provider.dart';
import 'package:yeetfit/features/plans/presentation/utils/plan_display.dart';
import 'package:yeetfit/features/sessions/domain/entities/training_session.dart';
import 'package:yeetfit/features/sessions/presentation/providers/session_provider.dart';
import 'package:yeetfit/features/sessions/presentation/widgets/live_sessions_section.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/providers/user_role_provider.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../providers/explore_provider.dart';
import '../widgets/explore_body.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _joinSession(
    BuildContext context,
    TrainingSession session,
  ) async {
    final uri = Uri.tryParse(session.meetLink);
    var launched = false;
    if (uri != null) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Opening Meet link failed: $e');
      }
    }
    if (!launched && context.mounted) {
      _showMessage(context, "Couldn't open the session link.");
    }
  }

  Future<void> _remindSession(
    BuildContext context,
    WidgetRef ref,
    TrainingSession session,
  ) async {
    String message;
    try {
      final scheduled = await ref
          .read(sessionReminderControllerProvider.notifier)
          .remind(session);
      message = scheduled
          ? "We'll remind you 15 minutes before it starts."
          : 'This session starts in less than 15 minutes.';
    } catch (e) {
      debugPrint('Scheduling session reminder failed: $e');
      message = "Couldn't set a reminder. Please try again.";
    }
    if (context.mounted) _showMessage(context, message);
  }

  Future<void> _deleteSession(
    BuildContext context,
    WidgetRef ref,
    TrainingSession session,
  ) async {
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Delete session?',
      message: '"${session.title}" will be removed for everyone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    final deleted = await ref
        .read(createSessionControllerProvider.notifier)
        .delete(session.id);
    if (!deleted && context.mounted) {
      _showMessage(context, "Couldn't delete the session. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(explorePlansProvider);
    final selectedTab = ref.watch(exploreTabProvider);
    final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final now = ref.watch(sessionClockProvider).value ?? DateTime.now();
    final remindedSessionIds =
        ref.watch(sessionReminderControllerProvider).value ?? const {};
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final userId = ref.watch(authUserIdProvider);
    // Admins see their own sessions; members see their assigned coach's.
    // A member with no coach gets null, and the section hides when empty.
    final currentCoachId = ref
        .watch(currentCoachIdProvider(userId ?? ''))
        .asData
        ?.value;
    final coachId = isAdmin ? userId : (userId == null ? null : currentCoachId);
    // Coaches see every session they posted. Clients only see global
    // sessions and ones that list their uid.
    final currentUserId = isAdmin ? null : userId;
    final sessions = ref.watch(
      visibleSessionsProvider((
        coachId: coachId,
        currentUserId: currentUserId,
      )),
    );
    // Keeps the controller alive while a delete is in flight.
    ref.watch(createSessionControllerProvider);

    ref.listen(exploreFavoriteControllerProvider, (_, event) {
      final message = switch (event) {
        PlanFavoriteToggled(:final isFavorite) =>
          isFavorite ? 'Added to favorites' : 'Removed from favorites',
        PlanFavoriteToggleFailed(:final message) => message,
        null => null,
      };
      if (message == null) return;
      _showMessage(context, message);
      ref.read(exploreFavoriteControllerProvider.notifier).consume();
    });

    final searchActive = ref.watch(exploreSearchActiveProvider);

    return PopScope(
      canPop: !searchActive,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !searchActive) return;
        ref.read(exploreSearchQueryProvider.notifier).clear();
        ref.read(exploreSearchActiveProvider.notifier).setActive(false);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ExploreBody(
          sessionsSection: LiveSessionsSection(
            sessions: sessions,
            now: now,
            remindedSessionIds: remindedSessionIds,
            isAdmin: isAdmin,
            onJoin: (session) => _joinSession(context, session),
            onRemind: (session) => _remindSession(context, ref, session),
            onDelete: (session) => _deleteSession(context, ref, session),
            onCreate: () => context.push(SessionRouteConstants.create),
            // The header only builds once the section is visible, so the tour
            // waits until there is something to point at.
            headerWrapper: userId == null
                ? null
                : (header) => WalkthroughTrigger(
                    tourKey: WalkthroughController.explore,
                    userId: userId,
                    targets: ExploreTour.targets,
                    child: YanaShowcase(
                      step: ExploreTour.sessions,
                      child: header,
                    ),
                  ),
          ),
          plans: plans,
          selectedTab: selectedTab,
          onTabSelected: (tab) =>
              ref.read(exploreTabProvider.notifier).select(tab),
          favoritesOnly: favoritesOnly,
          onPlanTap: (plan) {
            final planId = plan.id;
            if (planId == null) return;
            context.push(
              PlansRouteConstants.detailPath(plan.routeCategory, planId),
            );
          },
          onToggleFavorite: (plan) => ref
              .read(exploreFavoriteControllerProvider.notifier)
              .toggleFavorite(plan),
          onRetry: () => ref
            ..invalidate(allWorkoutPlansProvider)
            ..invalidate(allDietPlansProvider)
            ..invalidate(
              upcomingSessionsProvider((
                coachId: coachId,
                currentUserId: currentUserId,
              )),
            ),
        ),
      ),
    );
  }
}
