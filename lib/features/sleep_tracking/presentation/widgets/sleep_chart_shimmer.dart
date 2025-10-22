import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

// Shimmer placeholder for sleep chart loading.
class SleepChartShimmer extends StatelessWidget {
  const SleepChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      child: Shimmer.fromColors(
        baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
        highlightColor: AppTheme.colors['gray']!.withOpacity(0.7),
        child: Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: AppTheme.colors['white'],
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
