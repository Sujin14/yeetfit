import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_calories_card.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_entry_dialog.dart';
import '../widgets/steps_progress_card.dart';
import '../widgets/steps_tip_card.dart';
import '../providers/steps_provider.dart';

class StepCounterScreen extends ConsumerWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track steps')),
      );
    }

    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    final today = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: const StepsAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final steps = ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0));
                            final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
                            final progressColor = ref.watch(dailyStepsProgressColorProvider('$userId|$today'));
                            return StepsProgressCard(
                              steps: steps,
                              goalSteps: goalSteps,
                              progressColor: progressColor,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        Consumer(
                          builder: (context, ref, _) {
                            final caloriesBurned = ref.watch(caloriesBurnedProvider(userId));
                            final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
                            return StepsCaloriesCard(
                              caloriesBurned: caloriesBurned,
                              goalCalories: goalSteps * 0.04,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        const StepsTipCard(),
                      ],
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20.w : 10.w),
                  Expanded(child: StepsChartCard(userId: userId)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final steps = ref.watch(stepsCountProvider(userId).select((value) => value.value ?? 0));
                      final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
                      final progressColor = ref.watch(dailyStepsProgressColorProvider('$userId|$today'));
                      return StepsProgressCard(
                        steps: steps,
                        goalSteps: goalSteps,
                        progressColor: progressColor,
                      );
                    },
                  ),
                  SizedBox(height: 18.h),
                  Consumer(
                    builder: (context, ref, _) {
                      final caloriesBurned = ref.watch(caloriesBurnedProvider(userId));
                      final goalSteps = ref.watch(stepsGoalProvider(userId).select((value) => value.value ?? 10000));
                      return StepsCaloriesCard(
                        caloriesBurned: caloriesBurned,
                        goalCalories: goalSteps * 0.04,
                      );
                    },
                  ),
                  SizedBox(height: 18.h),
                  const StepsTipCard(),
                  SizedBox(height: 18.h),
                  StepsChartCard(userId: userId),
                  SizedBox(height: 60.h),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5).withOpacity(0.3),
        onPressed: () => _showStepsEntryDialog(context, ref, userId),
        child: const Icon(
          Icons.directions_walk_rounded,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showStepsEntryDialog(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) => StepsEntryDialog(userId: userId),
    );
  }
}