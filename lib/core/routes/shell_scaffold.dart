import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/challenge_route_constants.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import 'package:yeetfit/core/routes/chat_route_constants.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/features/challenges/domain/entities/challenge.dart';
import 'package:yeetfit/features/challenges/presentation/providers/challenge_provider.dart';
import 'package:yeetfit/features/challenges/presentation/providers/pending_challenge_provider.dart';
import 'package:yeetfit/features/chat/presentation/providers/pending_chat_provider.dart';
import 'package:yeetfit/features/dashboard/presentation/widgets/calendar_dialog.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/custom_appbar.dart';
import 'package:yeetfit/shared/widgets/glass_app_drawer.dart';
import 'package:yeetfit/shared/widgets/glass_bottom_nav_bar.dart';
import 'package:yeetfit/shared/widgets/no_internet_banner.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'navigation_enum.dart';

/// Scaffold wrapper for main app shell with the floating glass navigation bar.
class ShellScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Deferred: this can fire during initState, before routing is usable.
    ref.listenManual<ChatNotificationTap?>(pendingChatProvider, (_, tap) {
      if (tap == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openPendingChat(tap);
      });
    }, fireImmediately: true);
    ref.listenManual<ChallengeNotificationTap?>(pendingChallengeProvider, (
      _,
      tap,
    ) {
      if (tap == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openPendingChallenge(tap);
      });
    }, fireImmediately: true);
  }

  // Nav index 2 is the Track action, so branches 2+ sit one nav slot later.
  int _getIndexFromLocation(int branchIndex) {
    return branchIndex > 1 ? branchIndex + 1 : branchIndex;
  }

  void _onIndexChanged(int index) {
    if (index == 2) return;
    final branchIndex = index > 2 ? index - 1 : index;
    widget.navigationShell.goBranch(branchIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndexFromLocation(
      widget.navigationShell.currentIndex,
    );
    final currentTab = NavigationTab.values[currentIndex];
    final isDashboard = currentTab == NavigationTab.dashboard;

    // Back on any other tab returns to the dashboard; only the dashboard
    // lets the system close the app.
    return PopScope(
      canPop: isDashboard,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) widget.navigationShell.goBranch(0);
      },
      // Hosts the dashboard, Explore and Progress tours. It sits above the app bar and
      // nav bar because the dashboard tour spotlights buttons in both.
      child: ShowCaseWidget(
        enableAutoScroll: true,
        onFinish: WalkthroughController.finishActive,
        builder: (context) => ShellGradientBackground(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            drawer: const GlassAppDrawer(),
            appBar: CustomAppBar(
              title: currentTab.title,
              showCalendar: isDashboard,
              onCalendar: _showCalendarDialog,
              showCoachChat: isDashboard,
              onCoachChat: _openCoachChat,
              coachChatWrapper: (button) =>
                  YanaShowcase(step: DashboardTour.coachChat, child: button),
              scaffoldKey: _scaffoldKey,
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      const NoInternetBanner(),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: widget.navigationShell,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GlassBottomNavBar(
                    currentIndex: currentIndex,
                    onIndexChanged: _onIndexChanged,
                    trackButtonWrapper: (button) => YanaShowcase(
                      step: DashboardTour.trackButton,
                      child: button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ChatScreen resolves the chat from the coach's uid, so the push is only
  /// followed when its chatId is this client's chat with that coach.
  void _openPendingChat(ChatNotificationTap tap) {
    ref.read(pendingChatProvider.notifier).clear();
    final userId = ref.read(authUserIdProvider);
    if (userId == null || tap.senderId == userId) return;

    final ids = [userId, tap.senderId]..sort();
    if (tap.chatId != ids.join('_')) {
      debugPrint('Ignoring chat notification for chat ${tap.chatId}');
      return;
    }

    final current = GoRouter.of(context).routerDelegate.currentConfiguration;
    if (current.uri.path == ChatRouteConstants.chat &&
        current.extra == tap.senderId) {
      return;
    }
    context.push(ChatRouteConstants.chat, extra: tap.senderId);
  }

  /// The detail route needs the whole challenge, so it is loaded first; the
  /// challenges list is the fallback when it can't be.
  Future<void> _openPendingChallenge(ChallengeNotificationTap tap) async {
    ref.read(pendingChallengeProvider.notifier).clear();
    if (ref.read(authUserIdProvider) == null) return;

    final challenge = await _loadChallenge(tap.challengeId);
    if (!mounted) return;

    final current = GoRouter.of(context).routerDelegate.currentConfiguration;
    if (challenge == null) {
      if (current.uri.path != ChallengeRouteConstants.root) {
        context.push(ChallengeRouteConstants.root);
      }
      return;
    }
    final shown = current.extra;
    if (current.uri.path == ChallengeRouteConstants.detail &&
        shown is Challenge &&
        shown.id == challenge.id) {
      return;
    }
    context.push(ChallengeRouteConstants.detail, extra: challenge);
  }

  Future<Challenge?> _loadChallenge(String? challengeId) async {
    if (challengeId == null) return null;
    try {
      return await ref
          .read(challengeDataSourceProvider)
          .getChallenge(challengeId);
    } catch (e) {
      debugPrint('Loading challenge from notification failed: $e');
      return null;
    }
  }

  void _openCoachChat() {
    if (ref.read(authUserIdProvider) == null) return;
    context.push(ChatRouteConstants.adminList);
  }

  void _showCalendarDialog() {
    if (ref.read(authUserIdProvider) == null) return;
    showDialog(context: context, builder: (context) => const CalendarDialog());
  }
}
