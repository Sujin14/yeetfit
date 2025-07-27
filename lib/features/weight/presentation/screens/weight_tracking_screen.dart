import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print('WeightTrackingScreen: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    if (userId == null) {
      print('WeightTrackingScreen: No authenticated user');
      return const Scaffold(
        body: Center(child: Text('Please log in to track weight')),
      );
    }

    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    print('WeightTrackingScreen: Building UI for userId=$userId, isDesktop=$isDesktop');

    return Scaffold(
      appBar: const WeightAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const WeightGoalSection(),
                        SizedBox(height: 16.h),
                        Consumer(
                          builder: (context, ref, _) {
                            print('WeightTrackingScreen: Watching weightGoalProvider for userId=$userId');
                            final goalAsync = ref.watch(weightGoalProvider(userId));
                            return goalAsync.when(
                              data: (goal) {
                                print('WeightTrackingScreen: Goal data for userId=$userId: goalWeight=${goal.goalWeight}');
                                return WeightCard(
                                  title: 'Goal Weight',
                                  weight: goal.goalWeight,
                                );
                              },
                              loading: () {
                                print('WeightTrackingScreen: Loading goal for userId=$userId');
                                return const CircularProgressIndicator();
                              },
                              error: (error, _) {
                                print('WeightTrackingScreen: Error in weightGoalProvider for userId=$userId: $error');
                                return Text('Error: $error');
                              },
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        Consumer(
                          builder: (context, ref, _) {
                            print('WeightTrackingScreen: Watching currentWeightProvider for userId=$userId');
                            final weightAsync = ref.watch(currentWeightProvider(userId));
                            return weightAsync.when(
                              data: (weight) {
                                print('WeightTrackingScreen: Current weight for userId=$userId: $weight');
                                return WeightCard(
                                  title: 'Current Weight',
                                  weight: weight,
                                );
                              },
                              loading: () {
                                print('WeightTrackingScreen: Loading weight for userId=$userId');
                                return const CircularProgressIndicator();
                              },
                              error: (error, _) {
                                print('WeightTrackingScreen: Error in currentWeightProvider for userId=$userId: $error');
                                return Text('Error: $error');
                              },
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        const WeightTipCard(),
                      ],
                    ),
                  ),
                  SizedBox(width: isDesktop ? 24.w : 16.w),
                  Expanded(child: WeightChartSection(userId: userId)),
                ],
              )
            : Column(
                children: [
                  const WeightGoalSection(),
                  SizedBox(height: 16.h),
                  Consumer(
                    builder: (context, ref, _) {
                      print('WeightTrackingScreen: Watching weightGoalProvider (mobile) for userId=$userId');
                      final goalAsync = ref.watch(weightGoalProvider(userId));
                      return goalAsync.when(
                        data: (goal) {
                          print('WeightTrackingScreen: Goal data (mobile) for userId=$userId: goalWeight=${goal.goalWeight}');
                          return WeightCard(
                            title: 'Goal Weight',
                            weight: goal.goalWeight,
                          );
                        },
                        loading: () {
                          print('WeightTrackingScreen: Loading goal (mobile) for userId=$userId');
                          return const CircularProgressIndicator();
                        },
                        error: (error, _) {
                          print('WeightTrackingScreen: Error in weightGoalProvider (mobile) for userId=$userId: $error');
                          return Text('Error: $error');
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  Consumer(
                    builder: (context, ref, _) {
                      print('WeightTrackingScreen: Watching currentWeightProvider (mobile) for userId=$userId');
                      final weightAsync = ref.watch(currentWeightProvider(userId));
                      return weightAsync.when(
                        data: (weight) {
                          print('WeightTrackingScreen: Current weight (mobile) for userId=$userId: $weight');
                          return WeightCard(
                            title: 'Current Weight',
                            weight: weight,
                          );
                        },
                        loading: () {
                          print('WeightTrackingScreen: Loading weight (mobile) for userId=$userId');
                          return const CircularProgressIndicator();
                        },
                        error: (error, _) {
                          print('WeightTrackingScreen: Error in currentWeightProvider (mobile) for userId=$userId: $error');
                          return Text('Error: $error');
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  Consumer(
                    builder: (context, ref, _) {
                      print('WeightTrackingScreen: Watching weightProgressProvider for userId=$userId');
                      final progressData = ref.watch(weightProgressProvider(userId));
                      print('WeightTrackingScreen: Progress data for userId=$userId: progress=${progressData['progress']}');
                      return WeightProgressBar(
                        progress: progressData['progress'],
                        progressColor: progressData['color'],
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
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
          print('WeightTrackingScreen: Opening WeightEntryDialog for userId=$userId');
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