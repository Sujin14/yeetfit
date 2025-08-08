import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../widgets/steps_action_button.dart';
import '../widgets/steps_animation.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_action_sheet.dart';
import '../widgets/steps_calorie_card_container.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_progress_card_container.dart';
import '../widgets/steps_tip_card.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_tracking_toggle.dart';

class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _usePedometer = true; //to enable pedometer by default

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('StepCounterScreen: No authenticated user');
      return const Scaffold(
        body: Center(child: Text('Please log in to track steps')),
      );
    }

    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Check if step goal is achieved
    ref.listen(stepsCountProvider(userId), (previous, next) {
      next.whenData((steps) {
        final goalAsync = ref.watch(stepsGoalProvider(userId));
        goalAsync.whenData((goalSteps) {
          if (steps >= goalSteps) {
            print(
              'StepCounterScreen: Goal steps achieved for userId=$userId, navigating to StepsSuccessPage',
            );
            context.push('/steps-success/$goalSteps');
          }
        });
      });
    });

    return Scaffold(
      appBar: const StepsAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(stepsCountProvider(userId));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepsAnimation(),
              StepsTrackingModeToggle(
                isPedometerActive: _usePedometer,
                onToggle: (value) {
                  setState(() {
                    _usePedometer = value;
                    ref
                        .read(stepsCountProvider(userId).notifier)
                        .togglePedometer(value);
                    if (value) {
                      ref.invalidate(stepsCountProvider(userId));
                    }
                  });
                },
              ),
              SizedBox(height: 16.h),
              StepsProgressCardContainer(userId: userId, today: today),
              SizedBox(height: 18.h),
              StepsCaloriesCardContainer(userId: userId),
              SizedBox(height: 18.h),
              const StepsTipCard(),
              SizedBox(height: 18.h),
              StepsChartSection(userId: userId),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
      floatingActionButton: StepsActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => StepsActionSheet(userId: userId),
          );
        },
      ),
    );
  }
}
