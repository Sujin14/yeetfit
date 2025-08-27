import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit/shared/theme/theme.dart';

class SleepChartShimmer extends StatelessWidget {
  const SleepChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
      highlightColor: AppTheme.colors['gray']!.withOpacity(0.7),
      child: Container(
        height: 220.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.colors['white'],
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}