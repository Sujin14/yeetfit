import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../data/model/food_model.dart';
import '../providers/food_provider.dart';

class CalorieChartCard extends ConsumerWidget {
  final String userId;

  const CalorieChartCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyFoodDataProvider(userId));

    return SizedBox(height: 350.h,
      child: GlassmorphicContainer(
        color: AppTheme.colors['indigo']!,
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Calorie Intake (Last 7 Days)',
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 220.h,
              child: weeklyDataAsync.when(
                data: (weeklyData) {
                  final maxGoal = weeklyData.values
                      .expand((list) => list)
                      .map((item) => item.calories)
                      .fold<double>(1750.0, (a, b) => a > b ? a : b);
                  final interval = maxGoal <= 2000 ? 400.0 : 800.0;
      
                  return BarChart(
                    BarChartData(
                      maxY: maxGoal < 2000 ? 2000 : (maxGoal + 200).clamp(2000, 4000),
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppTheme.colors['primaryText']!.withOpacity(0.7),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (index) {
                        final date = DateTime.now().subtract(Duration(days: 6 - index));
                        final dateString = DateFormat('yyyy-MM-dd').format(date);
      
                        double totalCalories = 0.0;
                        for (final mealType in weeklyData.keys) {
                          final dayData = weeklyData[mealType]!.firstWhere(
                            (entry) => entry.date == dateString,
                            orElse: () => FoodItem(
                              date: dateString,
                              mealType: mealType,
                              foodName: '',
                              calories: 0.0,
                              protein: 0.0,
                              fat: 0.0,
                              carbs: 0.0,
                              fiber: 0.0,
                              quantity: 0.0
                            ),
                          );
                          totalCalories += dayData.calories;
                        }
      
                        final progressColor = ref.watch(
                          dailyCalorieProgressColorProvider('$userId|$dateString'),
                        );
      
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: totalCalories,
                              width: 20.w,
                              color: progressColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameSize: 24.h,
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                              final label = DateFormat('EEE').format(date); // Mon, Tue, etc.
                              return Padding(
                                padding: EdgeInsets.only(top: 8.0.h),
                                child: Text(
                                  label,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    color: AppTheme.colors['primaryText']!,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(
                            'Calories',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
                            ),
                          ),
                          axisNameSize: 28.h,
                          sideTitles: SideTitles(
                            reservedSize: 30.w,
                            showTitles: true,
                            interval: interval,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: AppTheme.colors['primaryText']!.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: EdgeInsets.all(8.w),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(0)} Cal',
                              GoogleFonts.roboto(
                                color: AppTheme.colors['white']!,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 800),
                  );
                },
                loading: () => Center(
                  child: SizedBox(
                    height: 40.h,
                    width: 40.h,
                    child: CircularProgressIndicator(color: AppTheme.colors['white']),
                  ),
                ),
                error: (error, _) => Text(
                  'Error: $error',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: AppTheme.colors['white']!.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
