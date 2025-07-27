import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/sleep_model.dart';
import '../providers/sleep_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepChartSection extends ConsumerWidget {
  final String userId;

  const SleepChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklySleepDataProvider(userId));
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16 : 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 20 : 10),
          SizedBox(
            height: isDesktop ? 350 : 220,
            child: weeklyDataAsync.when(
              data: (weeklyData) {
                return BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBorderRadius: BorderRadius.circular(26),
                        tooltipPadding: EdgeInsets.all(isDesktop ? 2 : 5),
                        getTooltipItem: (group, _, rod, __) {
                          final date = DateTime.now().subtract(Duration(days: 6 - group.x));
                          final dateString = date.toIso8601String().split('T')[0];
                          final data = weeklyData.firstWhere(
                            (entry) => entry.date == dateString,
                            orElse: () => SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
                          );
                          return BarTooltipItem(
                            '${data.duration.toStringAsFixed(1)} hrs',
                            GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: isDesktop ? 10 : 12,
                            ),
                          );
                        },
                      ),
                    ),
                    maxY: 10,
                    minY: 0,
                    barGroups: List.generate(7, (index) {
                      final date = DateTime.now().subtract(Duration(days: 6 - index));
                      final dateString = date.toIso8601String().split('T')[0];
                      final data = weeklyData.firstWhere(
                        (entry) => entry.date == dateString,
                        orElse: () => SleepData(date: dateString, duration: 0.0, goalHours: 8.0),
                      );
                      final progressColor = ref.watch(dailySleepProgressColorProvider('$userId|$dateString'));
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.duration,
                            color: progressColor,
                            width: isDesktop ? 12 : 20,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: data.goalHours,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: isDesktop ? 18 : 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (index, _) {
                            final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                            return Text(
                              weekdays[index.toInt()],
                              style: GoogleFonts.roboto(
                                fontSize: isDesktop ? 10 : 14,
                                color: Colors.white,
                              ),
                            );
                          },
                          reservedSize: isDesktop ? 28 : 30,
                        ),
                      ),
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
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