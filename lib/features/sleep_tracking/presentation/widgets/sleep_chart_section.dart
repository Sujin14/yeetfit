import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/shared/widgets/chart_bars_shimmer.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/sleep_data.dart';
import '../providers/sleep_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Section for weekly sleep trend chart.
class SleepChartSection extends ConsumerWidget {
  final String userId;

  const SleepChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final weeklyDataAsync = ref.watch(weeklySleepDataProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep Analysis',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 220,
              child: weeklyDataAsync.when(
                data: (weeklyData) =>
                    _buildBarChart(context, weeklyData, startOfWeek, now),
                loading: () => const ChartBarsShimmer(),
                error: (error, _) => YeetErrorState.compact(
                  message: '$error',
                  onRetry: () => ref.invalidate(sleepHistoryProvider(userId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    List<SleepData> weeklyData,
    DateTime startOfWeek,
    DateTime now,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.textSecondary);
    // Determine max goal for chart scaling
    final maxGoal = weeklyData.isEmpty
        ? 8.0
        : weeklyData.map((d) => d.goalHours).reduce((a, b) => a > b ? a : b);
    final interval = maxGoal <= 10 ? 2.0 : 4.0;

    return BarChart(
      BarChartData(
        maxY: maxGoal < 10 ? 10 : (maxGoal + 2),
        minY: 0,
        backgroundColor: Colors.transparent,
        barGroups: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final dateString = date.toIso8601String().split('T')[0];

          final data = weeklyData.firstWhere(
            (entry) => entry.date == dateString,
            orElse: () =>
                SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
          );

          final level = ProgressLevel.fromRatio(
            data.goalHours > 0 ? data.duration / data.goalHours : 0,
          );
          final progressColor = colors.progressColor(level);

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.duration.clamp(0.0, data.goalHours),
                color: progressColor,
                width: 16,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: data.goalHours,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.05),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: 28,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: Text(value.toInt().toString(), style: labelStyle),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (index, _) {
                final date = startOfWeek.add(Duration(days: index.toInt()));
                final isToday =
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;

                final weekdays = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ];
                final dayName = weekdays[date.weekday - 1];

                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    isToday ? 'Today' : dayName,
                    style: labelStyle.copyWith(
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                      color: isToday ? colors.primary : colors.textSecondary,
                    ),
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
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 4,
            getTooltipItem: (group, _, rod, _) {
              final date = startOfWeek.add(Duration(days: group.x.toInt()));
              final dateString = date.toIso8601String().split('T')[0];
              final data = weeklyData.firstWhere(
                (entry) => entry.date == dateString,
                orElse: () =>
                    SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
              );
              return BarTooltipItem(
                '${data.duration.toStringAsFixed(1)}h',
                labelStyle.copyWith(
                  color: colors.onBackground,
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
