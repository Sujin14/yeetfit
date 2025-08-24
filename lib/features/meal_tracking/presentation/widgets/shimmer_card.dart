import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class ShimmerCard extends StatelessWidget {
  final bool isListTile; // For ListTile-style cards (e.g., FoodList, MealSection)
  final bool isChart; // For CalorieChartCard
  final bool isSummary; // For CalorieSummary
  final double height; // Custom height for specific use cases

  const ShimmerCard({
    super.key,
    this.isListTile = false,
    this.isChart = false,
    this.isSummary = false,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = AppTheme.colors['gray']!.withOpacity(0.3);
    final highlightColor = AppTheme.colors['white']!.withOpacity(0.1);

    if (isChart) {
      return SizedBox(
        height: 350.h,
        child: GlassmorphicContainer(
          color: AppTheme.colors['indigo']!,
          padding: EdgeInsets.all(24.w),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 20.h,
                  width: double.infinity,
                  color: baseColor,
                ),
                SizedBox(height: 24.h),
                Container(
                  height: 220.h,
                  color: baseColor,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isSummary) {
      return GlassmorphicContainer(
        color: AppTheme.colors['deepOrange']!,
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.h,
                        width: 120.w,
                        color: baseColor,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 28.h,
                    width: 28.w,
                    color: baseColor,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(4, (index) => SizedBox(
                  width: 150.w,
                  child: Column(
                    children: [
                      Container(
                        height: 14.h,
                        width: 100.w,
                        color: baseColor,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        height: 4.h,
                        width: double.infinity,
                        color: baseColor,
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      );
    }

    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(12.w),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: isListTile
            ? ListTile(
                contentPadding: EdgeInsets.zero,
                title: Container(
                  height: 16.h,
                  width: 100.w,
                  color: baseColor,
                ),
                subtitle: Container(
                  height: 14.h,
                  width: 80.w,
                  color: baseColor,
                ),
                trailing: Container(
                  height: 24.h,
                  width: 24.w,
                  color: baseColor,
                ),
              )
            : Container(
                height: height.h,
                color: baseColor,
              ),
      ),
    );
  }
}