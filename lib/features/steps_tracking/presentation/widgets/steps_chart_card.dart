import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/steps_provider.dart';

class StepsChartSection extends ConsumerWidget {
  final String userId;

  const StepsChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyStepsDataProvider(userId));
    final chartData = ref.watch(chartDataProvider(userId));
    final config = ref.watch(chartConfigProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Progress',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 200.h,
            child: weeklyDataAsync.when(
              data: (_) => BarChart(
                BarChartData(
                  maxY: config['maxY'],
                  minY: 0,
                  barGroups: List.generate(7, (index) {
                    final data = chartData[index];
                    final progressColor =
                        ref.watch(dailyStepsProgressColorProvider('$userId|${data.date}'));
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.steps > data.goalSteps ? data.goalSteps.toDouble() : data.steps.toDouble(),
                          width: 18.w,
                          color: progressColor,
                          borderRadius: BorderRadius.circular(6.r),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: data.goalSteps.toDouble(),
                            color: AppTheme.colors['cardBackground']!.withOpacity(0.2),
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
                          final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                          final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              isToday ? 'Today' : dayName,
                              style: AppTheme.textStyles['body']!.copyWith(
                                fontSize: 12.sp,
                                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                                color: isToday
                                    ? AppTheme.colors['onSurfaceDark']
                                    : AppTheme.colors['onSurfaceDark']!.withOpacity(0.6),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40.w,
                        interval: config['interval'],
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          final formattedValue = formatStepCount(value);
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Text(
                              formattedValue,
                              style: AppTheme.textStyles['body']!.copyWith(
                                fontSize: 12.sp,
                                color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.8),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, _, rod, __) {
                        final data = chartData[group.x.toInt()];
                        return BarTooltipItem(
                          '${data.steps} 👟',
                          AppTheme.textStyles['body']!.copyWith(
                            color: AppTheme.colors['onSurfaceDark'],
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(
                'Error: $error',
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['error'],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}