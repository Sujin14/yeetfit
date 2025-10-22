import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/sleep_model.dart';
import '../providers/sleep_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'sleep_chart_shimmer.dart';

// Section for weekly sleep trend chart.
class SleepChartSection extends ConsumerWidget {
  final String userId;

  const SleepChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklySleepDataProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday

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
              data: (weeklyData) => _buildBarChart(ref, weeklyData, startOfWeek, now),
              loading: () => const SleepChartShimmer(),
              error: (error, _) => Text('Error: $error', style: TextStyle(color: AppTheme.colors['white'])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    WidgetRef ref,
    List<SleepData> weeklyData,
    DateTime startOfWeek,
    DateTime now,
  ) {
    // Determine max goal for chart scaling
    final maxGoal = weeklyData.map((d) => d.goalHours).reduce((a, b) => a > b ? a : b);
    final interval = maxGoal <= 10 ? 2.0 : 4.0;

    return BarChart(
      BarChartData(
        maxY: maxGoal < 10 ? 10 : (maxGoal + 2),
        minY: 0,
        barGroups: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final dateString = date.toIso8601String().split('T')[0];

          final data = weeklyData.firstWhere(
            (entry) => entry.date == dateString,
            orElse: () => SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
          );

          final progressColor = ref.watch(dailySleepProgressColorProvider('$userId|$dateString'));

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
              getTitlesWidget: (value, _) => Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Text(
                  value.toInt().toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30.h,
              getTitlesWidget: (index, _) {
                final date = startOfWeek.add(Duration(days: index.toInt()));
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

                final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final dayName = weekdays[date.weekday - 1];

                return Text(
                  isToday ? 'Today' : dayName,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: AppTheme.colors['onSurface']!.withOpacity(isToday ? 1.0 : 0.8),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, __) {
              final date = startOfWeek.add(Duration(days: group.x.toInt()));
              final dateString = date.toIso8601String().split('T')[0];
              final data = weeklyData.firstWhere(
                (entry) => entry.date == dateString,
                orElse: () => SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
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
      ),
    );
  }
}