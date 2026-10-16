import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/shared/widgets/chart_bars_shimmer.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/steps_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Section for weekly steps chart.
class StepsChartSection extends ConsumerWidget {
  final String userId;

  const StepsChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final weeklyDataAsync = ref.watch(weeklyStepsDataProvider(userId));
    final chartData = ref.watch(chartDataProvider(userId));
    final config = ref.watch(chartConfigProvider(userId));
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.textSecondary);

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
                data: (_) => BarChart(
                  BarChartData(
                    maxY: config.maxY,
                    minY: 0,
                    backgroundColor: Colors.transparent,
                    barGroups: List.generate(7, (index) {
                      final data = chartData[index];
                      final progressColor = colors.progressColor(
                        ProgressLevel.fromRatio(
                          data.goalSteps > 0 ? data.steps / data.goalSteps : 0,
                        ),
                      );
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.steps > data.goalSteps
                                ? data.goalSteps.toDouble()
                                : data.steps.toDouble(),
                            width: 16,
                            color: progressColor,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: data.goalSteps.toDouble(),
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ],
                      );
                    }),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: config.interval,
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
                            final date = startOfWeek.add(
                              Duration(days: value.toInt()),
                            );
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
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
                              child: Text(
                                isToday ? 'Today' : dayName,
                                style: labelStyle.copyWith(
                                  fontWeight: isToday
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isToday
                                      ? colors.primary
                                      : colors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: config.interval,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.sm,
                              ),
                              child: Text(
                                formatStepCount(value),
                                style: labelStyle,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => colors.surface,
                        getTooltipItem: (group, _, rod, _) {
                          final data = chartData[group.x.toInt()];
                          return BarTooltipItem(
                            '${data.steps} 👟',
                            labelStyle.copyWith(color: colors.onBackground),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                loading: () => const ChartBarsShimmer(),
                error: (error, _) => YeetErrorState.compact(
                  message: '$error',
                  onRetry: () =>
                      ref.invalidate(weeklyStepsDataProvider(userId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
