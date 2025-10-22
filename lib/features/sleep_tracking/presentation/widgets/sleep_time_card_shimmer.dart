import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

/// Shimmer for sleep time cards loading.
class SleepTimeCardsShimmer extends StatelessWidget {
  const SleepTimeCardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
          highlightColor: AppTheme.colors['gray']!.withOpacity(0.1),
          child: Container(width: 100.w, height: 18.h, decoration: BoxDecoration(color: AppTheme.colors['white'], borderRadius: BorderRadius.circular(4.r))),
        ),
        SizedBox(height: 30.h),
        GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          child: Shimmer.fromColors(
            baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
            highlightColor: AppTheme.colors['gray']!.withOpacity(0.3),
            child: Container(height: 56.h, decoration: BoxDecoration(color: AppTheme.colors['white'], borderRadius: BorderRadius.circular(12.r))),
          ),
        ),
        SizedBox(height: 25.h),
        GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          child: Shimmer.fromColors(
            baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
            highlightColor: AppTheme.colors['gray']!.withOpacity(0.1),
            child: Container(height: 56.h, decoration: BoxDecoration(color: AppTheme.colors['white'], borderRadius: BorderRadius.circular(12.r))),
          ),
        ),
      ],
    );
  }
}