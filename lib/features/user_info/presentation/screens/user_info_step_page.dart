// user_info_step_page.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_provider.dart';
import '../widgets/user_info_stepper.dart';
import '../../../../utils/fixed_sizes.dart';

class UserInfoStepPage extends ConsumerWidget {
  final int step;

  const UserInfoStepPage({super.key, required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoState = ref.watch(userInfoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: FixedSizes.font22(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userInfoState.when(
        data: (_) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.spacing(context),
            vertical: FixedSizes.spacing(context),
          ),
          child: UserInfoStepper(step: step),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                style: TextStyle(
                  fontSize: FixedSizes.font16(context),
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(height: FixedSizes.spacing(context)),
              ElevatedButton(
                onPressed: () => ref
                    .read(userInfoControllerProvider.notifier)
                    .fetchUserData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
