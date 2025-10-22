import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/routes/tracking_routes_constants.dart';
import '../providers/food_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

// Summary card for daily calorie intake.
class CalorieSummary extends ConsumerWidget {
  final double totalCalories;
  final Color progressColor;

  const CalorieSummary({
    super.key,
    required this.totalCalories,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final nutrients = ref.watch(dailyNutrientsProvider(userId));
    final nutrientGoals = ref.watch(nutrientGoalsProvider(userId));
    final goalCaloriesAsync = ref.watch(calorieGoalProvider(userId));

    return goalCaloriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error loading goal: $e"),
      data: (goalCalories) => GlassmorphicContainer(
        color: AppTheme.colors['deepOrange']!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: CircularProgressIndicator(
                        value: goalCalories > 0
                            ? totalCalories / goalCalories
                            : 0.0,
                        strokeWidth: 6,
                        backgroundColor: AppTheme.colors['white']!.withOpacity(
                          0.2,
                        ),
                        valueColor: AlwaysStoppedAnimation(progressColor),
                      ),
                    ),
                    Icon(
                      Icons.local_dining,
                      size: 28,
                      color: AppTheme.colors['indigo'],
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    '${totalCalories.toStringAsFixed(0)} of ${goalCalories.toStringAsFixed(0)} Cal',
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors['onSurface'],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.go(TrackingRouteConstants.weeklyCalorieChart),
                  child: Icon(
                    Icons.bar_chart,
                    color: AppTheme.colors['indigo'],
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Nutrient progress rows
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 8.w) / 2;
                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildNutrientProgress(
                      'Protein',
                      nutrients['protein']!,
                      nutrientGoals['protein']!,
                      AppTheme.colors['navBarActive']!,
                      itemWidth,
                    ),
                    _buildNutrientProgress(
                      'Fat',
                      nutrients['fat']!,
                      nutrientGoals['fat']!,
                      AppTheme.colors['error']!,
                      itemWidth,
                    ),
                    _buildNutrientProgress(
                      'Carbs',
                      nutrients['carbs']!,
                      nutrientGoals['carbs']!,
                      AppTheme.colors['fullProgress']!,
                      itemWidth,
                    ),
                    _buildNutrientProgress(
                      'Fiber',
                      nutrients['fiber']!,
                      nutrientGoals['fiber']!,
                      AppTheme.colors['indigo']!,
                      itemWidth,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientProgress(
    String label,
    double value,
    double goal,
    Color color,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toStringAsFixed(1)} / ${goal.toStringAsFixed(0)}g',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: goal > 0 ? value / goal : 0.0,
            backgroundColor: AppTheme.colors['white']!.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }
}
