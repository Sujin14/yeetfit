import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class BMIShimmerCard extends StatelessWidget {
  const BMIShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Shimmer.fromColors(
      baseColor: colors.onSurface.withOpacity(0.2),
      highlightColor: colors.onSurface.withOpacity(0.4),
      child: Container(
        width: double.infinity,
        height: 220.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.primary.withOpacity(0.3)),
        ),
      ),
    );
  }
}
