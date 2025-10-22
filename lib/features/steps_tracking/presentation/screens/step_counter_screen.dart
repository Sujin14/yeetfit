import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/tracking_routes_constants.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_animation.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_calorie_card_container.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_progress_card_container.dart';
import '../widgets/steps_tip_card.dart';

// Main screen for steps tracking.
class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Please log in to track steps')));
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final isDesktop = ScreenUtil().screenWidth >= 600.w;

    ref.listen(stepsCountProvider(userId), (previous, next) {
      next.whenData((steps) {
        final goalAsync = ref.watch(stepsGoalProvider(userId));
        goalAsync.whenData((goalSteps) {
          if (steps >= goalSteps && !_hasNavigated) {
            _hasNavigated = true;
            context.push(TrackingRouteConstants.stepsSuccess.replaceAll(':goal', goalSteps.toString())).then((_) {
              if (mounted) setState(() => _hasNavigated = false);
            });
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
      ),
    );
  }
}