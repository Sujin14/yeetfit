import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';

class MealTrackingCard extends ConsumerWidget {
  final Map<String, dynamic>? progress;
  final String userId;
  final bool isLoading;

  const MealTrackingCard({
    super.key,
    required this.progress,
    required this.userId,
    this.isLoading = false,
  });

  const MealTrackingCard.loading({
    super.key,
    this.progress,
    required this.userId,
  }) : isLoading = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
        highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
        child: _buildShimmerCard(context),
      );
    }

    return _buildCardContent(context, ref);
  }

  Widget _buildCardContent(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));

    return progressAsync.when(
      data: (data) {
        final calories = data['calories']?.toDouble() ?? 0.0;
        final caloriesGoal = data['caloriesGoal']?.toDouble() ?? 3500.0;
        final protein = data['protein']?.toDouble() ?? 0.0;
        final proteinGoal = data['proteinGoal']?.toDouble() ?? 150.0;
        final carbs = data['carbs']?.toDouble() ?? 0.0;
        final carbsGoal = data['carbsGoal']?.toDouble() ?? 300.0;
        final fat = data['fat']?.toDouble() ?? 0.0;
        final fatGoal = data['fatGoal']?.toDouble() ?? 70.0;

        return GestureDetector(
          onTap: () => context.push('/modal/food', extra: userId),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 300.h,
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
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal Tracking',
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 16.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 60.r,
                                      lineWidth: 10.w,
                                      percent: (calories / caloriesGoal).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      progressColor:
                                          AppTheme.colors['caloriesProgress'],
                                      backgroundColor: AppTheme
                                          .colors['secondaryText']!
                                          .withOpacity(0.2),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                    CircularPercentIndicator(
                                      radius: 45.r,
                                      lineWidth: 8.w,
                                      percent: (protein / proteinGoal).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      progressColor:
                                          AppTheme.colors['proteinProgress'],
                                      backgroundColor: AppTheme
                                          .colors['secondaryText']!
                                          .withOpacity(0.2),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                    CircularPercentIndicator(
                                      radius: 30.r,
                                      lineWidth: 6.w,
                                      percent: (carbs / carbsGoal).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      progressColor:
                                          AppTheme.colors['carbsProgress'],
                                      backgroundColor: AppTheme
                                          .colors['secondaryText']!
                                          .withOpacity(0.2),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                    CircularPercentIndicator(
                                      radius: 15.r,
                                      lineWidth: 4.w,
                                      percent: (fat / fatGoal).clamp(0.0, 1.0),
                                      progressColor:
                                          AppTheme.colors['fatProgress'],
                                      backgroundColor: AppTheme
                                          .colors['secondaryText']!
                                          .withOpacity(0.2),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      center: Icon(
                                        Icons.local_fire_department,
                                        size: 10.sp,
                                        color: AppTheme.colors['primaryText'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  'Eat balanced meals with whole foods!',
                                  style: AppTheme.textStyles['body']!.copyWith(
                                    fontSize: 12.sp,
                                    color: AppTheme.colors['primaryText'],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroContainer(
                              'Calories',
                              '${calories.toInt()}/${caloriesGoal.toInt()} kcal',
                              AppTheme.colors['caloriesProgress']!,
                            ),
                            _buildMacroContainer(
                              'Protein',
                              '${protein.toInt()}/${proteinGoal.toInt()} g',
                              AppTheme.colors['proteinProgress']!,
                            ),
                            _buildMacroContainer(
                              'Carbs',
                              '${carbs.toInt()}/${carbsGoal.toInt()} g',
                              AppTheme.colors['carbsProgress']!,
                            ),
                            _buildMacroContainer(
                              'Fat',
                              '${fat.toInt()}/${fatGoal.toInt()} g',
                              AppTheme.colors['fatProgress']!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
        highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
        child: _buildShimmerCard(context),
      ),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['error'],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroContainer(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 1.5.w),
          ),
          child: Center(
            child: Text(
              value.split('/')[0],
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: 16.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: 12.sp,
            color: AppTheme.colors['secondaryText'],
          ),
        ),
        Text(
          value,
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: 12.sp,
            color: AppTheme.colors['secondaryText'],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 300.h,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              height: 16.h,
              color: AppTheme.colors['white'],
            ),
            SizedBox(height: 6.h),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.colors['white'],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Container(
                            width: double.infinity,
                            height: 40.h,
                            color: AppTheme.colors['white'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      4,
                      (_) => Container(
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.colors['white'],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
