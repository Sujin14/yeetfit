import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/daily_progress_provider.dart';

class MealTrackingCard extends ConsumerWidget {
  final Map<String, dynamic>? progress;
  final String userId;
  final bool isLoading;

  const MealTrackingCard({super.key, required this.progress, required this.userId, this.isLoading = false});
  const MealTrackingCard.loading({super.key, this.progress, required this.userId}) : isLoading = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return isLoading
        ? Shimmer.fromColors(
            baseColor: colors.onSurface.withOpacity(0.2),
            highlightColor: colors.onSurface.withOpacity(0.4),
            child: _buildShimmerCard(colors),
          )
        : _buildCardContent(context, ref, colors);
  }

  Widget _buildCardContent(BuildContext context, WidgetRef ref, AppColors colors) {
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
            linearGradient: LinearGradient(colors: [colors.navAccent.withOpacity(0.1), colors.navAccent.withOpacity(0.05)]),
            borderGradient: LinearGradient(colors: [colors.primary, colors.secondary]),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Meal Tracking', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp)),
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
                                    CircularPercentIndicator(radius: 60.r, lineWidth: 10.w, percent: (calories / caloriesGoal).clamp(0.0, 1.0), progressColor: colors.calories, backgroundColor: colors.onSurface.withOpacity(0.2), circularStrokeCap: CircularStrokeCap.round),
                                    CircularPercentIndicator(radius: 45.r, lineWidth: 8.w, percent: (protein / proteinGoal).clamp(0.0, 1.0), progressColor: colors.protein, backgroundColor: colors.onSurface.withOpacity(0.2), circularStrokeCap: CircularStrokeCap.round),
                                    CircularPercentIndicator(radius: 30.r, lineWidth: 6.w, percent: (carbs / carbsGoal).clamp(0.0, 1.0), progressColor: colors.carbs, backgroundColor: colors.onSurface.withOpacity(0.2), circularStrokeCap: CircularStrokeCap.round),
                                    CircularPercentIndicator(radius: 15.r, lineWidth: 4.w, percent: (fat / fatGoal).clamp(0.0, 1.0), progressColor: colors.fat, backgroundColor: colors.onSurface.withOpacity(0.2), circularStrokeCap: CircularStrokeCap.round, center: Icon(Icons.local_fire_department, size: 10.sp, color: colors.onSurface)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text('Eat balanced meals with whole foods!', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12.sp), textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroContainer('Calories', '${calories.toInt()}/${caloriesGoal.toInt()} kcal', colors.calories, context),
                            _buildMacroContainer('Protein', '${protein.toInt()}/${proteinGoal.toInt()} g', colors.protein, context),
                            _buildMacroContainer('Carbs', '${carbs.toInt()}/${carbsGoal.toInt()} g', colors.carbs, context),
                            _buildMacroContainer('Fat', '${fat.toInt()}/${fatGoal.toInt()} g', colors.fat, context),
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
      loading: () => Shimmer.fromColors(baseColor: colors.onSurface.withOpacity(0.2), highlightColor: colors.onSurface.withOpacity(0.4), child: _buildShimmerCard(colors)),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMacroContainer(String title, String value, Color color, BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2), border: Border.all(color: color, width: 1.5.w)),
          child: Center(child: Text(value.split('/')[0], style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16.sp))),
        ),
        SizedBox(height: 2.h),
        Text(title, style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp)),
        Text(value, style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildShimmerCard(AppColors colors) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 300.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(colors: [colors.navAccent.withOpacity(0.1), colors.navAccent.withOpacity(0.05)]),
      borderGradient: LinearGradient(colors: [colors.primary, colors.secondary]),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100.w, height: 16.h, color: Colors.white),
            SizedBox(height: 6.h),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Center(child: Container(width: 120.w, height: 120.h, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white)))),
                      Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 8.w), child: Container(width: double.infinity, height: 40.h, color: Colors.white))),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (_) => Container(width: 35.w, height: 35.h, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}