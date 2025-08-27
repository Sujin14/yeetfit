import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/sleep_model.dart';
import '../providers/sleep_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'sleep_chart_shimmer.dart';

class SleepChartSection extends ConsumerWidget {
  final String userId;

  const SleepChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklySleepDataProvider(userId));

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 220.h,
            child: weeklyDataAsync.when(
              data: (weeklyData) => _buildBarChart(context, ref, weeklyData),
              loading: () => const SleepChartShimmer(),
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
    List<SleepData> weeklyData,
  ) {
    final maxGoal = weeklyData
        .map((d) => d.goalHours)
        .fold<double>(0.0, (a, b) => a > b ? a : b);
    final interval = maxGoal <= 10 ? 2.0 : 4.0;

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0,
            fitInsideHorizontally: true,
            getTooltipItem: (group, _, rod, __) {
              final date = DateTime.now().subtract(Duration(days: 6 - group.x));
              final dateString = date.toIso8601String().split('T')[0];
              final data = weeklyData.firstWhere(
                (entry) => entry.date == dateString,
                orElse: () =>
                    SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
              );
              return BarTooltipItem(
                '${data.duration.toStringAsFixed(1)} hrs',
                GoogleFonts.roboto(
                  color: AppTheme.colors['white'],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        maxY: maxGoal < 10 ? 10 : (maxGoal + 2),
        minY: 0,
        barGroups: List.generate(7, (index) {
          final date = DateTime.now().subtract(Duration(days: 6 - index));
          final dateString = date.toIso8601String().split('T')[0];
          final data = weeklyData.firstWhere(
            (entry) => entry.date == dateString,
            orElse: () =>
                SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
          );
          final progressColor = ref.watch(
            dailySleepProgressColorProvider('$userId|$dateString'),
          );

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.duration.clamp(0.0, data.goalHours),
                color: progressColor,
                width: 20.w,
                borderRadius: BorderRadius.circular(6.r),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: data.goalHours,
                  color: AppTheme.colors['primaryText']!.withOpacity(0.2),
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: 30.w,
              getTitlesWidget: (value, _) {
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Text(
                    value.toInt().toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30.h,
              getTitlesWidget: (index, _) {
                final weekdays = [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                ];
                return Text(
                  weekdays[index.toInt()],
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
        ),
      ),
    );
  }
}
