
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_animation.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_calorie_card_container.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_progress_card_container.dart';
import '../widgets/steps_tip_card.dart';

class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _usePedometer = true; // Initialize pedometer as active by default
  bool _hasNavigated = false; // Flag to prevent multiple navigations

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to track steps',
            style: TextStyle(color: AppTheme.colors['primaryText']),
          ),
        ),
      );
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final isDesktop = ScreenUtil().screenWidth >= 600.w;

    return Scaffold(
      appBar: const StepsAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          // Listen to stepsCountProvider to detect goal achievement
          ref.listen(stepsCountProvider(userId), (previous, next) {
            next.whenData((steps) {
              final goalAsync = ref.watch(stepsGoalProvider(userId));
              goalAsync.whenData((goalSteps) {
                if (steps >= goalSteps && !_hasNavigated) {
                  if (kDebugMode) {
                    print('StepCounterScreen: Goal steps achieved for userId=$userId, navigating to StepsSuccessPage');
                  }
                  _hasNavigated = true; // Set flag to prevent multiple navigations
                  context.push('/steps-success/$goalSteps').then((_) {
                    // Reset flag when returning from StepsSuccessPage
                    if (mounted) {
                      setState(() {
                        _hasNavigated = false;
                      });
                    }
                  });
                }
              });
            });
          });

          return SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const StepsAnimation(),
                  SizedBox(height: 18.h),
                  StepsProgressCardContainer(userId: userId, today: today),
                  SizedBox(height: 22.h),
                  StepsCaloriesCardContainer(userId: userId),
                  SizedBox(height: 22.h),
                  const StepsTipCard(),
                  SizedBox(height: 22.h),
                  StepsChartSection(userId: userId),
                ],
              ),
          );
        },
      ),
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);