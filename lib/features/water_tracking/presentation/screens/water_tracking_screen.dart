import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/tracking_shimmer.dart';
import 'package:yeetfit/shared/widgets/tracking_status_view.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/water_provider.dart';
import '../widgets/water_goal_dialog.dart';
import '../widgets/water_tracking_body.dart';

// Main screen for water tracking.
class WaterTrackingScreen extends ConsumerWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignInRequiredView(
            message: 'Please log in to track water intake',
          ),
        ),
      );
    }

    ref.listen(waterTrackingNavigationProvider(userId), (_, goalReached) {
      if (!goalReached) return;
      final goalGlasses =
          ref.read(todayWaterProvider(userId)).value?.goalGlasses ?? 8;
      ref.read(waterTrackingNavigationProvider(userId).notifier).reset();
      context.push(TrackingRouteConstants.waterSuccessPath('$goalGlasses'));
    });

    final waterAsync = ref.watch(todayWaterProvider(userId));
    final water = waterAsync.value;

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: switch (waterAsync) {
          AsyncValue(hasValue: true) => WaterTrackingBody(
            userId: userId,
            consumed: water?.glassesConsumed ?? 0,
            goal: water?.goalGlasses ?? 8,
            onAddGlass: () =>
                ref.read(todayWaterProvider(userId).notifier).addGlass(),
            onRemoveGlass: () =>
                ref.read(todayWaterProvider(userId).notifier).removeGlass(),
            onEditGoal: () => showDialog<void>(
              context: context,
              builder: (_) => WaterGoalDialog(userId: userId),
            ),
          ),
          AsyncError(:final error) => TrackingStatusView(
            title: 'Hydration',
            child: YeetErrorState(
              message: 'Could not load water intake: $error',
              onRetry: () => ref.invalidate(todayWaterProvider(userId)),
            ),
          ),
          _ => const TrackingStatusView(
            title: 'Hydration',
            child: TrackingShimmer(),
          ),
        },
      ),
    );
  }
}
