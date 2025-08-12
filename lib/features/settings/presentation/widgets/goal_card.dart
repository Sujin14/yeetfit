import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../../shared/theme/theme.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String goal;
  final VoidCallback onEdit;

  const GoalCard({
    super.key,
    required this.title,
    required this.icon,
    required this.goal,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          AppTheme.colors['navigationAccent']!.withOpacity(0.1),
          AppTheme.colors['navigationAccent']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [AppTheme.colors['gradientTextStart']!, AppTheme.colors['gradientTextEnd']!],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.colors['primaryText'], size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    goal,
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppTheme.colors['primaryText'], size: 20.sp),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}