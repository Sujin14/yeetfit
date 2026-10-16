import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/chart_bars_shimmer.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/weight_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Section for displaying weekly weight trend chart.
class WeightChartSection extends ConsumerWidget {
  final String userId;

  const WeightChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final weeklyDataAsync = ref.watch(weeklyWeightDataProvider(userId));
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
              'Weight Trend',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: weeklyDataAsync.when(
                data: (weeklyData) {
                  final goalWeight = weeklyData.isNotEmpty
                      ? weeklyData.last.goalWeight
                      : null;
                  final values = [
                    ...weeklyData.map((e) => e.currentWeight),
                    ?goalWeight,
                  ];
                  final minWeight = values.isNotEmpty
                      ? values.reduce((a, b) => a < b ? a : b) - 5
                      : 65.0;
                  final maxWeight = values.isNotEmpty
                      ? values.reduce((a, b) => a > b ? a : b) + 5
                      : 80.0;

                  return LineChart(
                    LineChartData(
                      backgroundColor: Colors.transparent,
                      minY: minWeight,
                      maxY: maxWeight,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: Colors.white.withValues(alpha: 0.05),
                          strokeWidth: 1,
                        ),
                      ),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          if (goalWeight != null)
                            HorizontalLine(
                              y: goalWeight,
                              color: colors.secondary,
                              strokeWidth: 1.5,
                              dashArray: const [6, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                style: labelStyle.copyWith(
                                  color: colors.secondary,
                                ),
                                labelResolver: (_) => 'Goal',
                              ),
                            ),
                        ],
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= weeklyData.length) {
                                return const SizedBox.shrink();
                              }
                              final date = DateTime.tryParse(
                                weeklyData[index].date,
                              );
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.sm,
                                ),
                                child: Text(
                                  date?.day.toString() ?? '',
                                  style: labelStyle,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 5,
                            getTitlesWidget: (value, meta) =>
                                Text('${value.toInt()}', style: labelStyle),
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            weeklyData.length,
                            (index) => FlSpot(
                              index.toDouble(),
                              weeklyData[index].currentWeight,
                            ),
                          ),
                          isCurved: true,
                          preventCurveOverShooting: true,
                          color: colors.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                colors.primary.withValues(alpha: 0.25),
                                colors.primary.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const ChartBarsShimmer(),
                error: (error, _) => YeetErrorState.compact(
                  message: '$error',
                  onRetry: () => ref.invalidate(weightHistoryProvider(userId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
