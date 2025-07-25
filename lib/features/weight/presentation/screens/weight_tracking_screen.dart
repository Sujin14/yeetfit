import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../widgets/weight_app_bar.dart';
import '../widgets/weight_card.dart';
import '../widgets/weight_chart_section.dart';
import '../widgets/weight_goal_section.dart';
import '../widgets/weight_progress_bar.dart';
import '../widgets/weight_tip_card.dart';


class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
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
                        const WeightCard(title: 'Goal Weight', weight: 70.0),
                        SizedBox(height: 16.h),
                        const WeightCard(title: 'Current Weight', weight: 72.5),
                        SizedBox(height: 16.h),
                        const WeightTipCard(),
                      ],
                    ),
                  ),
                  SizedBox(width: isDesktop ? 24.w : 16.w),
                  const Expanded(child: WeightChartSection()),
                ],
              )
            : Column(
                children: [
                  const WeightGoalSection(),
                  SizedBox(height: 16.h),
                  const WeightCard(title: 'Goal Weight', weight: 70.0),
                  SizedBox(height: 16.h),
                  const WeightCard(title: 'Current Weight', weight: 72.5),
                  SizedBox(height: 16.h),
                  const WeightProgressBar(),
                  SizedBox(height: 16.h),
                  const WeightTipCard(),
                  SizedBox(height: 16.h),
                  const WeightChartSection(),
                  SizedBox(height: 60.h),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
        onPressed: () => context.push('/modal/weight'),
        child: Icon(
          Icons.scale,
          size: 22.sp,
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }
}