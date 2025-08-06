import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_calories_card.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_entry_dialog.dart';
import '../widgets/steps_goal.dart';
import '../widgets/steps_progress_card.dart';
import '../widgets/steps_tip_card.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';

class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _usePedometer = false;

  @override
  void initState() {
    super.initState();
    _checkGoal();
  }

  void _checkGoal() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final goalAsync = ref.read(stepsGoalProvider(userId));
    goalAsync.whenData((goalSteps) {
      if (goalSteps == 10000) {
        // Default value indicates no goal set
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showStepsGoalDialog(context, ref, userId);
        });
      }
    });
  }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              child: Lottie.asset(
                'assets/animations/running.json',
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step Tracking Mode',
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 16.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
                Switch(
                  value: _usePedometer,
                  onChanged: (value) {
                    setState(() {
                      _usePedometer = value;
                    });
                  },
                  activeColor: AppTheme.colors['teal'],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Consumer(
              builder: (context, ref, _) {
                final stepsAsync = ref.watch(stepsCountProvider(userId));
                final goalSteps = ref.watch(
                  stepsGoalProvider(
                    userId,
                  ).select((value) => value.value ?? 10000),
                );
                final progressColor = ref.watch(
                  dailyStepsProgressColorProvider('$userId|$today'),
                );
                return stepsAsync.when(
                  data: (steps) => StepsProgressCard(
                    steps: steps,
                    goalSteps: goalSteps,
                    progressColor: progressColor,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                );
              },
            ),
            SizedBox(height: 18.h),
            Consumer(
              builder: (context, ref, _) {
                final caloriesBurned = ref.watch(
                  caloriesBurnedProvider(userId),
                );
                final goalSteps = ref.watch(
                  stepsGoalProvider(
                    userId,
                  ).select((value) => value.value ?? 10000),
                );
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
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
        onPressed: () {
          if (_usePedometer) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Using pedometer for step tracking'),
              ),
            );
          } else {
            _showStepsEntryDialog(context, ref, userId);
          }
        },
        child: Icon(
          _usePedometer ? Icons.sensors : Icons.directions_walk_rounded,
          size: 22.sp,
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }

  void _showStepsEntryDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => StepsEntryDialog(userId: userId),
    );
  }

  void _showStepsGoalDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => StepsGoalDialog(userId: userId),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
