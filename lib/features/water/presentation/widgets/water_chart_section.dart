import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      color: const Color(0xFF3F51B5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
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
                      final data = weeklyData.firstWhere(
                        (entry) => entry.date == date.toIso8601String().split('T')[0],
                        orElse: () => WaterData(date: date.toIso8601String().split('T')[0], glassesConsumed: 0, goalGlasses: 8),
                      );
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.glassesConsumed.toDouble(),
                            width: 18,
                            color: const Color(0xFF26A69A),
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: data.goalGlasses.toDouble(),
                              color: Colors.white.withOpacity(0.1),
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
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
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