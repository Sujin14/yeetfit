import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_controller.dart';
import '../widgets/user_info_stepper.dart';

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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userInfoState.when(
        data: (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: UserInfoStepper(step: step),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error', style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.error)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref.read(userInfoControllerProvider.notifier).fetchUserData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}