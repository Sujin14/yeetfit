import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/water_model.dart';
import '../providers/water_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterChartSection extends ConsumerWidget {
  final String userId;

  const WaterChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyWaterDataProvider(userId));

    return GlassmorphicContainer(
      color: AppTheme.colors['waterChartBackground']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Progress',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.colors['white'],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: weeklyDataAsync.when(
              data: (weeklyData) {
                return BarChart(
                  BarChartData(
                    barGroups: List.generate(7, (index) {
                      final date = DateTime.now().subtract(Duration(days: 6 - index));
                      final dateString = date.toIso8601String().split('T')[0];
                      final data = weeklyData.firstWhere(
                        (entry) => entry.date == dateString,
                        orElse: () => WaterData(date: dateString, glassesConsumed: 0, goalGlasses: 8),
                      );
                      final progressColor = ref.watch(dailyProgressColorProvider('$userId|$dateString'));
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.glassesConsumed.toDouble(),
                            width: 18,
                            color: progressColor,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: data.goalGlasses.toDouble(),
                              color: AppTheme.colors['lightBackground']!,
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
                          reservedSize: 32,
                          getTitlesWidget: (value, _) {
                            final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                            final dateString = date.toIso8601String().split('T')[0];
                            final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dayName,
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error: $error', style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}