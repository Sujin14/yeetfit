import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/tracking_shimmer.dart';
import 'package:yeetfit/shared/widgets/tracking_status_view.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/weight_provider.dart';
import '../widgets/weight_entry_dialog.dart';
import '../widgets/weight_tracking_body.dart';

/// Main screen for weight tracking.
class WeightTrackingScreen extends ConsumerStatefulWidget {
  const WeightTrackingScreen({super.key});

  @override
  ConsumerState<WeightTrackingScreen> createState() =>
      _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends ConsumerState<WeightTrackingScreen> {
  bool _entryDialogOpen = false;

  Future<void> _openEntryDialog(String userId) async {
    _entryDialogOpen = true;
    await showDialog<void>(
      context: context,
      builder: (_) => WeightEntryDialog(userId: userId),
    );
    _entryDialogOpen = false;
  }

  void _onSaveResult(String userId, AsyncValue<WeightSaveResult?> next) {
    final messenger = ScaffoldMessenger.of(context);
    switch (next) {
      case AsyncData(value: final result?):
        ref.read(weightSaveControllerProvider(userId).notifier).consume();
        if (_entryDialogOpen) Navigator.of(context, rootNavigator: true).pop();
        if (result.goalReached) {
          context.push(
            TrackingRouteConstants.weightSuccessPath(
              result.goalWeight!.toStringAsFixed(1),
            ),
          );
        } else {
          messenger.showSnackBar(const SnackBar(content: Text('Weight saved')));
        }
      case AsyncError(:final error):
        ref.read(weightSaveControllerProvider(userId).notifier).consume();
        messenger.showSnackBar(SnackBar(content: Text('$error')));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const ShellGradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SignInRequiredView(message: 'Please log in to track weight'),
        ),
      );
    }

    ref.listen(
      weightSaveControllerProvider(userId),
      (_, next) => _onSaveResult(userId, next),
    );

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: switch (ref.watch(currentWeightProvider(userId))) {
          AsyncValue(hasValue: true) => WeightTrackingBody(
            userId: userId,
            onLogWeight: () => _openEntryDialog(userId),
          ),
          AsyncError(:final error) => TrackingStatusView(
            title: 'Weight',
            child: YeetErrorState(
              message: 'Could not load weight: $error',
              onRetry: () => ref.invalidate(currentWeightProvider(userId)),
            ),
          ),
          _ => const TrackingStatusView(
            title: 'Weight',
            child: TrackingShimmer(),
          ),
        },
      ),
    );
  }
}
