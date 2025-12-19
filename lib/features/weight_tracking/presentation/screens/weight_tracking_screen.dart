import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../providers/weight_provider.dart';
import '../widgets/weight_app_bar.dart';
import '../widgets/weight_cards_list.dart';
import '../widgets/weight_chart_section.dart';
import '../widgets/weight_goal_section.dart';
import '../widgets/weight_progress_bar.dart';
import '../widgets/weight_tip_card.dart';
import '../widgets/weight_entry_dialog.dart';
import '../../../../shared/theme/theme.dart';

/// Main screen for weight tracking.
class WeightTrackingScreen extends ConsumerWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track weight')),
      );
    }

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
                  progress: progressData['progress'] as double,
                  progressColor: progressData['color'] as Color,
                );
              },
            ),
            SizedBox(height: 16.h),
            WeightCardsList(userId: userId),
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
        onPressed: () => showDialog(
          context: context,
          builder: (context) => WeightEntryDialog(userId: userId),
        ),
        child: Icon(
          Icons.scale,
          size: 22.sp,
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }
}
