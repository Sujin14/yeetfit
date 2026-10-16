import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/tracking_shimmer.dart';
import 'package:yeetfit/shared/widgets/tracking_status_view.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_entry_sheet.dart';
import '../widgets/sleep_tracking_body.dart';

// Main screen for sleep tracking.
class SleepTrackingScreen extends ConsumerWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignInRequiredView(message: 'Please log in to track sleep'),
        ),
      );
    }

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: switch (ref.watch(todaySleepProvider(userId))) {
          AsyncValue(hasValue: true) => SleepTrackingBody(
            userId: userId,
            onLogSleep: () => SleepEntrySheet.show(context, userId: userId),
          ),
          AsyncError(:final error) => TrackingStatusView(
            title: 'Sleep',
            child: YeetErrorState(
              message: 'Could not load sleep data: $error',
              onRetry: () => ref.invalidate(todaySleepProvider(userId)),
            ),
          ),
          _ => const TrackingStatusView(
            title: 'Sleep',
            child: TrackingShimmer(),
          ),
        },
      ),
    );
  }
}
