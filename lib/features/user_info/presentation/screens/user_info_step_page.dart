import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/launch_gradient_background.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/user_info_provider.dart';
import '../widgets/user_info_shimmer.dart';
import '../widgets/user_info_stepper.dart';

class UserInfoStepPage extends ConsumerWidget {
  final int step;

  const UserInfoStepPage({super.key, required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoState = ref.watch(userInfoControllerProvider);

    return LaunchGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userInfoState.when(
          data: (_) => UserInfoStepper(step: step),
          loading: () => const UserInfoShimmer(),
          error: (error, _) => YeetErrorState(
            message: "Couldn't load your profile: $error",
            onRetry: () =>
                ref.read(userInfoControllerProvider.notifier).fetchUserData(),
          ),
        ),
      ),
    );
  }
}
