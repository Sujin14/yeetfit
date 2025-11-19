import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_colors.dart';

class BMIBackCard extends StatelessWidget {
  final double bmi;
  final String category;
  final String suggestion;
  final Color bmiColor;

  const BMIBackCard({
    super.key,
    required this.bmi,
    required this.category,
    required this.suggestion,
    required this.bmiColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final normalizedBMI = ((bmi - 18.5) / (24.9 - 18.5)).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 220.h,
        borderRadius: 16.r,
        blur: 8,
        border: 1.5,
        linearGradient: LinearGradient(
          colors: [bmiColor.withOpacity(0.15), bmiColor.withOpacity(0.05)],
        ),
        borderGradient: LinearGradient(
          colors: [bmiColor.withOpacity(0.8), bmiColor],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 50.r,
                lineWidth: 8.w,
                percent: normalizedBMI,
                center: Text(
                  bmi.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: bmiColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                progressColor: bmiColor,
                backgroundColor: colors.onSurface.withOpacity(0.15),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Category: $category',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16.sp,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14.sp,
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.refresh_rounded,
                color: colors.onSurface.withOpacity(0.6),
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
