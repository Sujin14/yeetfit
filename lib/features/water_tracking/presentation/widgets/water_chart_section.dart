import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/water_model.dart';
import '../providers/water_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'water_chart_shimmer.dart';

// Section for weekly water trend chart.
class WaterChartSection extends ConsumerWidget {
  final String userId;

  const WaterChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyWaterDataProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Progress',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppTheme.colors['white'],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 200.h,
            child: weeklyDataAsync.when(
              data: (weeklyData) =>
                  _buildBarChart(context, ref, weeklyData, startOfWeek, now),
              loading: () => const WaterChartShimmer(),
              error: (error, _) => Text(
                'Error: $error',
                style: TextStyle(color: AppTheme.colors['white']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    WidgetRef ref,
    List<WaterData> weeklyData,
    DateTime startOfWeek,
    DateTime now,
  ) {
    final cachedWeeklyData =
        ref.watch(weeklyWaterDataProvider(userId)).value ?? [];

    return BarChart(
      BarChartData(
        barGroups: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final dateString = date.toIso8601String().split('T')[0];
          final isToday =
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          final data = isToday
              ? WaterData(
                  date: dateString,
                  glassesConsumed:
                      ref.watch(glassesConsumedProvider(userId)).value ?? 0,
                  goalGlasses: ref.watch(waterGoalProvider(userId)).value ?? 8,
                )
              : cachedWeeklyData.firstWhere(
                  (entry) => entry.date == dateString,
                  orElse: () => WaterData(
                    date: dateString,
                    glassesConsumed: 0,
                    goalGlasses: 8,
                  ),
                );

          final progressColor = ref.watch(
            dailyProgressColorProvider('$userId|$dateString'),
          );

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.glassesConsumed > data.goalGlasses
                    ? data.goalGlasses.toDouble()
                    : data.glassesConsumed.toDouble(),
                width: 18.w,
                color: progressColor,
                borderRadius: BorderRadius.circular(6.r),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: data.goalGlasses.toDouble(),
                  color: AppTheme.colors['lightBackground']!,
                ),
              ),
            ],
          );
        }),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32.h,
              getTitlesWidget: (value, _) {
                final date = startOfWeek.add(Duration(days: value.toInt()));
                final isToday =
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
                final dayName = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ][date.weekday - 1];
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    isToday ? 'Today' : dayName,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday
                          ? AppTheme.colors['white']
                          : AppTheme.colors['white']?.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }
}
