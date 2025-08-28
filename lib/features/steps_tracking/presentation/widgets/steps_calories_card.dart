import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsCaloriesCard extends StatelessWidget {
  final double caloriesBurned;
  final double goalCalories;

  const StepsCaloriesCard({
    super.key,
    required this.caloriesBurned,
    required this.goalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories Burned',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: isDesktop ? 16.sp : 18.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: AppTheme.colors['borderGradientStart']),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Goal:',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontSize: isDesktop ? 14.sp : 16.sp,
                  color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
                ),
              ),
              Text(
                '${goalCalories.toStringAsFixed(0)} Cal 🔥',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 14.sp : 16.sp,
                  color: AppTheme.colors['onSurfaceDark'],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Burn:',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontSize: isDesktop ? 14.sp : 16.sp,
                  color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
                ),
              ),
              Text(
                '${caloriesBurned.toStringAsFixed(0)} Cal 🔥',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 14.sp : 16.sp,
                  color: AppTheme.colors['onSurfaceDark'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}