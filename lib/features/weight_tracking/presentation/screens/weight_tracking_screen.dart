import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../widgets/weight_app_bar.dart';
import '../widgets/weight_card.dart';
import '../widgets/weight_chart_section.dart';
import '../widgets/weight_goal_section.dart';
import '../widgets/weight_progress_bar.dart';
import '../widgets/weight_tip_card.dart';
import '../widgets/weight_entry_dialog.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';

class WeightTrackingScreen extends ConsumerWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track weight')),
      );
    }

    final currentWeightAsync = ref.watch(currentWeightProvider(userId));
    final goalAsync = ref.watch(weightGoalProvider(userId));

    // Check if goal weight is achieved
    ref.listen(currentWeightProvider(userId), (previous, next) {
      next.whenData((currentWeight) {
        goalAsync.whenData((goal) {
          if ((currentWeight - goal.goalWeight).abs() < 0.1) {
            context.push(
              '/weight-success/${goal.goalWeight.toStringAsFixed(1)}',
            );
          }
        });
      });
    });

    return Scaffold(
      appBar: const WeightAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
              child: Lottie.asset(
                'assets/animations/weight.json',
                fit: BoxFit.contain,
              ),
            ),
            const WeightGoalSection(),
            SizedBox(height: 25.h),
            Consumer(
              builder: (context, ref, _) {
                final progressData = ref.watch(weightProgressProvider(userId));
                return WeightProgressBar(
                  progress: progressData['progress'],
                  progressColor: progressData['color'],
                );
              },
            ),
            SizedBox(height: 16.h),
            Consumer(
              builder: (context, ref, _) {
                print(
                  'WeightTrackingScreen: Watching weightGoalProvider for goal weight (mobile) for userId=$userId',
                );
                final goalAsync = ref.watch(weightGoalProvider(userId));
                return goalAsync.when(
                  data: (goal) {
                    print(
                      'WeightTrackingScreen: Goal data (mobile) for userId=$userId: goalWeight=${goal.goalWeight}',
                    );
                    return WeightCard(
                      title: 'Goal Weight',
                      weight: goal.goalWeight,
                    );
                  },
                  loading: () {
                    print(
                      'WeightTrackingScreen: Loading goal (mobile) for userId=$userId',
                    );
                    return const CircularProgressIndicator();
                  },
                  error: (error, _) {
                    print(
                      'WeightTrackingScreen: Error in weightGoalProvider (mobile) for userId=$userId: $error',
                    );
                    return Text('Error: $error');
                  },
                );
              },
            ),
            SizedBox(height: 25.h),
            Consumer(
              builder: (context, ref, _) {
                print(
                  'WeightTrackingScreen: Watching weightGoalProvider for initial weight (mobile) for userId=$userId',
                );
                final goalAsync = ref.watch(weightGoalProvider(userId));
                return goalAsync.when(
                  data: (goal) {
                    print(
                      'WeightTrackingScreen: Initial weight data (mobile) for userId=$userId: initialWeight=${goal.initialWeight}',
                    );
                    return WeightCard(
                      title: 'Initial Weight',
                      weight: goal.initialWeight,
                    );
                  },
                  loading: () {
                    print(
                      'WeightTrackingScreen: Loading initial weight (mobile) for userId=$userId',
                    );
                    return const CircularProgressIndicator();
                  },
                  error: (error, _) {
                    print(
                      'WeightTrackingScreen: Error in weightGoalProvider for initial weight (mobile) for userId=$userId: $error',
                    );
                    return Text('Error: $error');
                  },
                );
              },
            ),
            SizedBox(height: 25.h),
            Consumer(
              builder: (context, ref, _) {
                print(
                  'WeightTrackingScreen: Watching currentWeightProvider (mobile) for userId=$userId',
                );
                final weightDataAsync = ref.watch(
                  currentWeightProvider(userId),
                );

                return weightDataAsync.when(
                  data: (weight) {
                    final today = DateTime.now().toIso8601String().split(
                      'T',
                    )[0];
                    print(
                      'WeightTrackingScreen: Current weight (mobile) for userId=$userId: $weight, date=$today',
                    );

                    return WeightCard(
                      title: 'Current Weight',
                      weight: weight,
                      date: today,
                    );
                  },
                  loading: () {
                    print(
                      'WeightTrackingScreen: Loading weight data (mobile) for userId=$userId',
                    );
                    return const CircularProgressIndicator();
                  },
                  error: (error, _) {
                    print(
                      'WeightTrackingScreen: Error in currentWeightProvider (mobile) for userId=$userId: $error',
                    );
                    return Text('Error: $error');
                  },
                );
              },
            ),

            SizedBox(height: 25.h),
            const WeightTipCard(),
            SizedBox(height: 16.h),
            WeightChartSection(userId: userId),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
        onPressed: () {
          print(
            'WeightTrackingScreen: Opening WeightEntryDialog for userId=$userId',
          );
          showDialog(
            context: context,
            builder: (context) => WeightEntryDialog(userId: userId),
          );
        },
        child: Icon(
          Icons.scale,
          size: 22.sp,
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }
}
