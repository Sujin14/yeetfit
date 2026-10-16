import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import 'settings_shimmer.dart';

/// Loads the signed-in user's profile and hands it to a settings form.
class SettingsProfileBody extends ConsumerWidget {
  final Widget Function(UserInfoModel userInfo) builder;

  const SettingsProfileBody({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(userInfoControllerProvider)
        .when(
          loading: () => const SettingsShimmer(),
          error: (error, _) => YeetErrorState(
            message: 'Could not load your profile: $error',
            onRetry: () =>
                ref.read(userInfoControllerProvider.notifier).fetchUserData(),
          ),
          data: builder,
        );
  }
}
