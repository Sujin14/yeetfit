import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/weight_provider.dart';

class WeightChartSection extends ConsumerWidget {
  final String userId;
  const WeightChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyWeightDataProvider(userId));

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Trend',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font18(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          SizedBox(
            height: FixedSizes.box200(context),
            child: weeklyDataAsync.when(
              data: (weeklyData) {
                final minWeight = weeklyData.isNotEmpty
                    ? weeklyData.map((e) => e.currentWeight).reduce((a, b) => a < b ? a : b) - 5
                    : 65.0;
                final maxWeight = weeklyData.isNotEmpty
                    ? weeklyData.map((e) => e.currentWeight).reduce((a, b) => a > b ? a : b) + 5
                    : 80.0;

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppTheme.colors['onSurface']!.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: FixedSizes.box30(context),
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                            return Padding(
                              padding: EdgeInsets.only(top: FixedSizes.box8(context)),
                              child: Text(
                                date.day.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: FixedSizes.font12(context),
                                  color: AppTheme.colors['onSurface'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: FixedSizes.box40(context),
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()} kg',
                            style: GoogleFonts.roboto(
                              fontSize: FixedSizes.font12(context),
                              color: AppTheme.colors['onSurface'],
                            ),
                          ),
                          interval: 5,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                            weeklyData.length,
                            (i) => FlSpot(i.toDouble(), weeklyData[i].currentWeight)),
                        isCurved: true,
                        color: AppTheme.colors['teal']!,
                        barWidth: 4,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: AppTheme.colors['teal']!.withOpacity(0.2)),
                      ),
                    ],
                    minY: minWeight,
                    maxY: maxWeight,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e', style: TextStyle(color: AppTheme.colors['onSurface'])),
            ),
          ),
        ],
      ),
    );
  }
}
