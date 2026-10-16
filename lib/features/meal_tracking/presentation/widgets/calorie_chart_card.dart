import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/chart_bars_shimmer.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/food_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Total calories per day for the last 7 days against the daily goal.
class CalorieChartCard extends ConsumerWidget {
  final String userId;

  const CalorieChartCard({super.key, required this.userId});

  static const double _chartHeight = 240;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final weeklyAsync = ref.watch(weeklyFoodDataProvider(userId));
    final goal =
        ref
            .watch(nutritionTargetsProvider(userId))
            .value
            ?.calories
            .toDouble() ??
        0;

    final today = DateTime.now();
    final days = List.generate(
      7,
      (index) => DateTime(today.year, today.month, today.day - (6 - index)),
    );
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 16),
        child: weeklyAsync.when(
          loading: () => const SizedBox(
            height: _chartHeight + 48,
            child: ChartBarsShimmer(),
          ),
          error: (_, _) => SizedBox(
            height: _chartHeight + 48,
            child: YeetErrorState.compact(
              message: "Couldn't load this week's meals.",
              onRetry: () => ref.invalidate(weeklyFoodDataProvider(userId)),
            ),
          ),
          data: (weeklyItems) {
            final totalsByDate = <String, double>{};
            for (final item in weeklyItems) {
              totalsByDate[item.date] =
                  (totalsByDate[item.date] ?? 0) + item.calories;
            }
            final totals = [
              for (final day in days)
                totalsByDate[dateFormat.format(day)] ?? 0.0,
            ];
            final loggedDays = totals.where((total) => total > 0).length;
            final average = loggedDays == 0
                ? 0
                : totals.reduce((a, b) => a + b) / loggedDays;
            final peak = math.max(totals.reduce(math.max), goal);
            final interval = math.max(250.0, (peak / 4 / 250).ceil() * 250.0);
            final maxY = interval * 5;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: Text(
                    'Last 7 days',
                    style: textTheme.titleMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2, bottom: 20),
                  child: Text(
                    loggedDays == 0
                        ? 'No meals logged this week'
                        : 'Avg ${average.round()} kcal on logged days',
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  height: _chartHeight,
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: maxY,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: interval,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: Colors.white.withValues(alpha: 0.08),
                          strokeWidth: 1,
                        ),
                      ),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          if (goal > 0)
                            HorizontalLine(
                              y: goal,
                              color: colors.secondary,
                              strokeWidth: 1.5,
                              dashArray: const [6, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                style: textTheme.bodySmall!.copyWith(
                                  color: colors.secondary,
                                ),
                                labelResolver: (_) => 'Goal ${goal.round()}',
                              ),
                            ),
                        ],
                      ),
                      barGroups: [
                        for (var index = 0; index < totals.length; index++)
                          BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: totals[index],
                                width: 18,
                                color: colors.primary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            ],
                          ),
                      ],
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) => Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
                              child: Text(
                                DateFormat('E').format(days[value.toInt()]),
                                style: textTheme.bodySmall!.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: interval,
                            getTitlesWidget: (value, meta) => Text(
                              value.round().toString(),
                              style: textTheme.bodySmall!.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => colors.surface,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              BarTooltipItem(
                                '${rod.toY.round()} kcal',
                                textTheme.bodySmall!.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
