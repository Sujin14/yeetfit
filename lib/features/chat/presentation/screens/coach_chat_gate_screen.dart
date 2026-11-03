import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/features/coaches/presentation/providers/coach_provider.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/coach_chat_gate_empty.dart';
import '../widgets/coach_chat_gate_loading.dart';
import 'chat_screen.dart';

/// Resolves the client's assigned coach, then embeds [ChatScreen] so Back
/// returns to the dashboard (not an intermediate list).
class CoachChatGateScreen extends ConsumerWidget {
  const CoachChatGateScreen({super.key});

  void _findCoach(BuildContext context) {
    context.go(ShellRouteConstants.coaches);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignInRequiredView(message: 'Please log in to chat'),
        ),
      );
    }

    final coachState = ref.watch(myCoachProvider(userId));

    return switch (coachState) {
      MyCoachLoading() => const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CoachChatGateLoading(),
        ),
      ),
      MyCoachNone() => ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CoachChatGateEmpty(
            title: "You don't have a coach yet",
            body:
                'Choose a coach to start chatting and get personalised plans.',
            onFindCoach: () => _findCoach(context),
          ),
        ),
      ),
      MyCoachUnavailable() => ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CoachChatGateEmpty(
            title: 'Your coach is no longer available',
            body: 'Choose a new coach to continue chatting.',
            onFindCoach: () => _findCoach(context),
          ),
        ),
      ),
      MyCoachReady(:final coach) => ChatScreen(
        adminId: coach.id,
        initialName: coach.name,
      ),
    };
  }
}
