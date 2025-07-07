import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';

class PlanCardWidget extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200.h,
      borderRadius: 20.r,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!,
          AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.sp, color: AppTheme.colors['primaryText']),
              SizedBox(height: 8.h),
              Text(
                title,
                style: AppTheme.textStyles['title']!.copyWith(
                  color: AppTheme.colors['primaryText'],
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$count plan${count == 1 ? '' : 's'}',
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['secondaryText'],
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
