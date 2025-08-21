import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';

class ProgressCard extends ConsumerWidget {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print(
        'ProgressCard: Building $title with percent=$percent for userId=$userId, isLoading=$isLoading',
      );
    }
    final progressColor = ref.watch(progressColorProvider(percent));

    return isLoading
        ? Shimmer.fromColors(
            baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
            highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
            child: _buildCard(
              context,
              progressColor: AppTheme.colors['secondaryText']!,
            ),
          )
        : GestureDetector(
            onTap: route != null
                ? () {
                    if (kDebugMode)
                      print(
                        'ProgressCard: Navigating to $route for userId=$userId',
                      );
                    context.push(route!, extra: userId);
                  }
                : null,
            child: _buildCard(context, progressColor: progressColor),
          );
  }

  Widget _buildCard(BuildContext context, {required Color progressColor}) {
    return GlassmorphicContainer(
      width: 360.w,
      height: 200.h,
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
       padding: EdgeInsets.symmetric(horizontal: 8.w), // Added horizontal padding
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: isLoading
                  ? _buildShimmerIndicator()
                  : CircularPercentIndicator(
                      radius: 50.r,
                      lineWidth: 8.w,
                      percent: percent.clamp(0.0, 1.0),
                      center: Icon(
                        icon,
                        size: 20.sp,
                        color: AppTheme.colors['primaryText'],
                      ),
                      progressColor: progressColor,
                      backgroundColor: AppTheme.colors['secondaryText']!
                          .withOpacity(0.2),
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
                            fontSize: 14.sp,
                            color: AppTheme.colors['primaryText'],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          value,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: 12.sp,
                            color: AppTheme.colors['secondaryText'],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          description,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: 10.sp,
                            color: AppTheme.colors['secondaryText']!
                                .withOpacity(0.7),
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
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.colors['white'],
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 100.w, height: 14.h, color: AppTheme.colors['white']),
        SizedBox(height: 4.h),
        Container(width: 80.w, height: 12.h, color: AppTheme.colors['white']),
        SizedBox(height: 4.h),
        Container(width: 150.w, height: 20.h, color: AppTheme.colors['white']),
      ],
    );
  }
}