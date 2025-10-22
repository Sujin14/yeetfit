import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../providers/water_provider.dart';
import '../widgets/water_action_button.dart';
import '../widgets/water_app_bar.dart';
import '../widgets/water_chart_section.dart';
import '../widgets/water_circular_indicator.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_tip_card.dart';
import '../../../../shared/theme/theme.dart';

// Main screen for water tracking.
class WaterTrackingScreen extends ConsumerWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track water intake')),
      );
    }

    ref.listen(waterTrackingNavigationProvider(userId), (previous, hasNavigated) {
      if (hasNavigated) {
        final goalGlasses = ref.read(waterGoalProvider(userId)).value ?? 8;
        context.goNamed('water-success', pathParameters: {'goal': goalGlasses.toString()});
      }
    });

    final consumed = ref.watch(glassesConsumedProvider(userId)).value ?? 0;
    final goal = ref.watch(waterGoalProvider(userId)).value ?? 8;
    final progress = goal > 0 ? consumed / goal : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      appBar: const WaterAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SizedBox(
            height: 150.h,
            child: Lottie.asset(
              'assets/animations/water.json',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16.h),
          const WaterProgressCard(),
          SizedBox(height: 30.h),
          WaterCircularIndicator(progress: progress),
          SizedBox(height: 15.h),
          WaterActionButtons(
            onAdd: () => ref.read(glassesConsumedProvider(userId).notifier).addGlass(),
            onRemove: () => ref.read(glassesConsumedProvider(userId).notifier).removeGlass(),
          ),
          SizedBox(height: 30.h),
          const WaterTipCard(),
          SizedBox(height: 30.h),
          WaterChartSection(userId: userId),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}