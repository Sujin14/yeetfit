import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_animation.dart';
import '../widgets/steps_progress_card_container.dart';
import '../widgets/steps_tip_card.dart';
import '../widgets/steps_tracking_toggle.dart';
import 'steps_calorie_card_container.dart';
import 'steps_chart_card.dart';

class StepsBody extends ConsumerWidget {
  final String userId;
  final bool isPedometerActive;
  final ValueChanged<bool> onToggle;

  const StepsBody({
    super.key,
    required this.userId,
    required this.isPedometerActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final isDesktop = ScreenUtil().screenWidth >= 600.w;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(stepsCountProvider(userId)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.w : 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StepsAnimation(),
            StepsTrackingModeToggle(
              isPedometerActive: isPedometerActive,
              onToggle: onToggle,
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
    );
  }
}