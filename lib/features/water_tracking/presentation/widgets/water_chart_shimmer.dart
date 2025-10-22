import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

// Shimmer placeholder for water chart loading.
class WaterChartShimmer extends StatelessWidget {
  const WaterChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
      highlightColor: AppTheme.colors['gray']!.withOpacity(0.1),
      child: SizedBox(
        height: 200.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final heights = [120, 150, 80, 100, 140, 110, 90];
            return Container(
              width: 18.w,
              height: heights[index].h,
              decoration: BoxDecoration(
                color: AppTheme.colors['white'],
                borderRadius: BorderRadius.circular(6.r),
              ),
            );
          }),
        ),
      ),
    );
  }
}