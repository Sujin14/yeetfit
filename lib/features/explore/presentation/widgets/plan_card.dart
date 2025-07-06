import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../shared/theme/theme.dart';

Widget buildPlanCard({
  required BuildContext context,
  required String title,
  required int count,
  required IconData icon,
  required VoidCallback onTap,
}) {
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

Widget buildLoadingCard() {
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
    child: Container(
      constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: 200.h),
      child: SkeletonLoader(
        builder: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppTheme.colors['navigationAccent']!.withOpacity(0.6),
          ),
        ),
        highlightColor: AppTheme.colors['navigationAccent']!,
        baseColor: AppTheme.colors['navigationAccent']!.withOpacity(0.4),
        period: const Duration(seconds: 1),
      ),
    ),
  );
}

Widget buildErrorCard(String error) {
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
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Text(
        'Error: $error',
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['error'],
          fontSize: 16.sp,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
