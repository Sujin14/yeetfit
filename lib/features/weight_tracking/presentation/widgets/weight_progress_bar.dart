import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

/// Progress bar for weight goal achievement.
class WeightProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;

  const WeightProgressBar({
    super.key,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress to Goal',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 8.h),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TweenAnimationBuilder(
                tween: ColorTween(begin: Colors.grey, end: progressColor),
                duration: const Duration(milliseconds: 300),
                builder: (context, color, child) => LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.r),
                  color: color,
                  backgroundColor: AppTheme.colors['onSurface']!.withOpacity(0.2),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}