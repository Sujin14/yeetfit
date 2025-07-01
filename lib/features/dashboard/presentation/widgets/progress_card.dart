import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../shared/theme/theme.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double percent;
  final String value;
  final IconData icon;
  final String description;

  const ProgressCard({
    super.key,
    required this.title,
    required this.percent,
    required this.value,
    required this.icon,
    required this.description,
  });

  // Get color based on percent
  Color get progressColor {
    if (percent < 0.25) return const Color(0xFFFF6B6B);
    if (percent < 0.5) return const Color(0xFFFFB347);
    if (percent < 0.75) return const Color(0xFFFFD700);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 340.w,
      height: 180.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!.withOpacity(0.1),
          AppTheme.colors['navigationAccent']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['gradientTextStart']!,
          AppTheme.colors['gradientTextEnd']!,
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: CircularPercentIndicator(
                radius: 40.r,
                lineWidth: 10.w,
                percent: percent.clamp(0.0, 1.0),
                center: Icon(
                  icon,
                  size: 24.sp,
                  color: AppTheme.colors['primaryText'],
                ),
                progressColor: progressColor,
                backgroundColor: AppTheme.colors['secondaryText']!.withOpacity(
                  0.2,
                ),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 16.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 12.sp,
                      color: AppTheme.colors['secondaryText']!.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
