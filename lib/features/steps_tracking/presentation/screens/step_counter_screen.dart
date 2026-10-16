import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/tracking_shimmer.dart';
import 'package:yeetfit/shared/widgets/tracking_status_view.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../../../core/routes/tracking_routes_constants.dart';
import '../providers/steps_provider.dart';
import '../widgets/step_counter_body.dart';
import '../widgets/steps_goal_dialogue.dart';

// Main screen for steps tracking.
class StepCounterScreen extends ConsumerWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignInRequiredView(message: 'Please log in to track steps'),
        ),
      );
    }

    ref.listen(stepsNavigationProvider(userId), (_, goalReached) {
      if (!goalReached) return;
      final goalSteps =
          ref.read(stepsGoalProvider(userId)).value ?? defaultStepsGoal;
      ref.read(stepsNavigationProvider(userId).notifier).reset();
      context.push(TrackingRouteConstants.stepsSuccessPath('$goalSteps'));
    });

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: switch (ref.watch(stepsCountProvider(userId))) {
          AsyncValue(hasValue: true) => StepCounterBody(
            userId: userId,
            onEditGoal: () => showDialog<void>(
              context: context,
              builder: (_) => StepsGoalDialog(
                userId: userId,
                initialGoal:
                    ref.read(stepsGoalProvider(userId)).value ??
                    defaultStepsGoal,
              ),
            ),
          ),
          AsyncError(:final error) => TrackingStatusView(
            title: 'Steps',
            child: YeetErrorState(
              message: 'Could not load steps: $error',
              onRetry: () => ref.invalidate(stepsCountProvider(userId)),
            ),
          ),
          _ => const TrackingStatusView(
            title: 'Steps',
            child: TrackingShimmer(),
          ),
        },
      ),
    );
  }
}
