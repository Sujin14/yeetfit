import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/bmi_provider.dart';

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
    this.route,
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
    final colors = Theme.of(context).extension<AppColors>()!;

    final progressKey = ref.watch(progressColorLogicProvider(percent));

    final Color progressColor = switch (progressKey) {
      'none' => colors.progressNone,
      '25' => colors.progress25,
      '50' => colors.progress50,
      _ => colors.progressFull,
    };

    return isLoading
        ? Shimmer.fromColors(
            baseColor: colors.onSurface.withOpacity(0.2),
            highlightColor: colors.onSurface.withOpacity(0.4),
            child: _buildCard(colors.onSurface, context),
          )
        : GestureDetector(
            onTap: route != null ? () => context.push(route!, extra: userId) : null,
            child: _buildCard(progressColor, context),
          );
  }

  Widget _buildCard(Color progressColor, BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return GlassmorphicContainer(
      width: 360.w,
      height: 200.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          colors.navAccent.withOpacity(0.1),
          colors.navAccent.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(colors: [colors.primary, colors.secondary]),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: isLoading
                  ? Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  : CircularPercentIndicator(
                      radius: 50.r,
                      lineWidth: 8.w,
                      percent: percent.clamp(0.0, 1.0),
                      center: Icon(icon, size: 20.sp, color: colors.onSurface),
                      progressColor: progressColor,
                      backgroundColor: colors.onSurface.withOpacity(0.2),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                        SizedBox(height: 4.h),
                        Container(width: 80.w, height: 12.h, color: Colors.white),
                        SizedBox(height: 4.h),
                        Container(width: 150.w, height: 20.h, color: Colors.white),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          value,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontSize: 10.sp,
                                color: colors.onSurface.withOpacity(0.7),
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
}