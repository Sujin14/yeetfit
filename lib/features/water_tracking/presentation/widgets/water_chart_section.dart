import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/shared/widgets/chart_bars_shimmer.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/water_data.dart';
import '../providers/water_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Section for weekly water trend chart.
class WaterChartSection extends ConsumerWidget {
  final String userId;

  const WaterChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final weeklyDataAsync = ref.watch(weeklyWaterDataProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: weeklyDataAsync.when(
                data: (weeklyData) =>
                    _buildBarChart(context, weeklyData, startOfWeek, now),
                loading: () => const ChartBarsShimmer(),
                error: (error, _) => YeetErrorState.compact(
                  message: '$error',
                  onRetry: () => ref.invalidate(waterHistoryProvider(userId)),
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
    List<WaterData> weeklyData,
    DateTime startOfWeek,
    DateTime now,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return BarChart(
      BarChartData(
        barGroups: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final dateString = date.toIso8601String().split('T')[0];
          final data = weeklyData.firstWhere(
            (entry) => entry.date == dateString,
            orElse: () =>
                WaterData(date: dateString, glassesConsumed: 0, goalGlasses: 8),
          );
          final level = ProgressLevel.fromRatio(
            data.goalGlasses > 0 ? data.glassesConsumed / data.goalGlasses : 0,
          );
          final progressColor = colors.progressColor(level);

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.glassesConsumed > data.goalGlasses
                    ? data.goalGlasses.toDouble()
                    : data.glassesConsumed.toDouble(),
                width: 16,
                color: progressColor,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: data.goalGlasses.toDouble(),
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ],
          );
        }),
        backgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.05),
            strokeWidth: 1,
          ),
        ),
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
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
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    isToday ? 'Today' : dayName,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                      color: isToday ? colors.primary : colors.textSecondary,
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
