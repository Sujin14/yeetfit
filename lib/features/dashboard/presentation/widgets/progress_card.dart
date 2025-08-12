import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double percent;
  final String value;
  final IconData icon;
  final String description;
  final String? route;
  final String userId;
  final bool isLoading;

  const ProgressCard({
    super.key,
    required this.title,
    required this.percent,
    required this.value,
    required this.icon,
    required this.description,
    required this.route,
    required this.userId,
    this.isLoading = false,
  });

  const ProgressCard.loading({
    super.key,
    this.title = '',
    this.percent = 0.0,
    this.value = '',
    this.icon = Icons.help,
    this.description = '',
    this.route,
    required this.userId,
  }) : isLoading = true;

  Color get progressColor {
    if (percent < 0.25) return const Color(0xFFFF6B6B);
    if (percent < 0.5) return const Color(0xFFFFB347);
    if (percent < 0.75) return const Color(0xFFFFD700);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    print('ProgressCard: Building $title with percent=$percent for userId=$userId, isLoading=$isLoading');
    return isLoading
        ? Shimmer.fromColors(
            baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
            highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
            child: _buildCard(context, isLoading: true),
          )
        : GestureDetector(
            onTap: route != null
                ? () {
                    print('ProgressCard: Navigating to $route for userId=$userId');
                    context.push(route!, extra: userId);
                  }
                : null,
            child: _buildCard(context, isLoading: false),
          );
  }

  Widget _buildCard(BuildContext context, {required bool isLoading}) {
    return GlassmorphicContainer(
      width: 340.w,
      height: 300.h, // Match MealTrackingCard
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
              child: isLoading
                  ? _buildShimmerIndicator()
                  : CircularPercentIndicator(
                      radius: 60.r, // Match MealTrackingCard
                      lineWidth: 10.w,
                      percent: percent.clamp(0.0, 1.0),
                      center: Icon(
                        icon,
                        size: 24.sp,
                        color: AppTheme.colors['primaryText'],
                      ),
                      progressColor: progressColor,
                      backgroundColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: isLoading
                  ? _buildShimmerContent()
                  : Column(
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

  Widget _buildShimmerIndicator() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.w,
          height: 16.h,
          color: Colors.white,
        ),
        SizedBox(height: 4.h),
        Container(
          width: 80.w,
          height: 14.h,
          color: Colors.white,
        ),
        SizedBox(height: 4.h),
        Container(
          width: 150.w,
          height: 24.h,
          color: Colors.white,
        ),
      ],
    );
  }
}