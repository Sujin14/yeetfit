import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../shared/theme/theme.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: 200.h,
        ),
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
}
