import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_action_button.dart';
import '../widgets/steps_action_sheet.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_body.dart';

class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _usePedometer = true; // Initialize pedometer as active by default
  bool _hasNavigated = false;
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to track steps',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['error'],
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    }

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

    return Scaffold(
      appBar: const StepsAppBar(),
      body: StepsBody(
        userId: userId,
        isPedometerActive: _usePedometer,
        onToggle: (value) {
          setState(() {
            _usePedometer = value;
            ref.read(stepsCountProvider(userId).notifier).togglePedometer(value);
            if (value) {
              ref.invalidate(stepsCountProvider(userId));
            }
          });
        },
      ),
      floatingActionButton: StepsActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: AppTheme.colors['transparent'],
          builder: (context) => StepsActionSheet(userId: userId),
        ),
      ),
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);