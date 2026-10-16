import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../../domain/entities/mood_fitness_correlation.dart';

/// Mood (1–5) and fitness completion (0–100%, scaled onto the same 0–5
/// axis) over the correlation window, each labelled at its last point.
class MoodCorrelationLineChart extends StatelessWidget {
  static const double _axisMax = 5;

  final List<MoodFitnessDay> days;

  const MoodCorrelationLineChart({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.textSecondary, fontSize: 10);
    final dateFormat = DateFormat.MMMd();

    final moodSpots = [
      for (var i = 0; i < days.length; i++)
        if (days[i].mood != null)
          FlSpot(i.toDouble(), days[i].mood!.toDouble()),
    ];
    final fitnessSpots = [
      for (var i = 0; i < days.length; i++)
        FlSpot(i.toDouble(), days[i].fitnessPercent / 100 * _axisMax),
    ];

    final moodBar = LineChartBarData(
      spots: moodSpots,
      color: colors.primary,
      barWidth: 3,
      isCurved: true,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      dotData: FlDotData(
        getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
          radius: 2.5,
          color: colors.primary,
          strokeWidth: 0,
        ),
      ),
    );
    final fitnessBar = LineChartBarData(
      spots: fitnessSpots,
      color: colors.secondary,
      barWidth: 2,
      isCurved: true,
      preventCurveOverShooting: true,
      dashArray: const [6, 4],
      dotData: const FlDotData(show: false),
    );
    final bars = [moodBar, fitnessBar];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (days.length - 1).toDouble(),
        minY: 0,
        maxY: _axisMax + 0.5,
        backgroundColor: Colors.transparent,
        lineBarsData: bars,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.05),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                if (value < 1 || value > _axisMax || value % 1 != 0) {
                  return const SizedBox.shrink();
                }
                return Text('${value.toInt()}', style: labelStyle);
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index % 5 != 0 || index >= days.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    dateFormat.format(days[index].date),
                    style: labelStyle,
                  ),
                );
              },
            ),
          ),
        ),
        showingTooltipIndicators: [
          if (moodSpots.isNotEmpty)
            ShowingTooltipIndicators([LineBarSpot(moodBar, 0, moodSpots.last)]),
          ShowingTooltipIndicators([
            LineBarSpot(fitnessBar, 1, fitnessSpots.last),
          ]),
        ],
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 6,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                LineTooltipItem(
                  spot.barIndex == 0 ? 'Mood' : 'Fitness',
                  labelStyle.copyWith(
                    color: spot.barIndex == 0
                        ? colors.primary
                        : colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
