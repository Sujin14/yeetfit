import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepChartSection extends StatelessWidget {
  const SleepChartSection({super.key});

  @override
  Widget build(BuildContext context) {
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
              fontSize: isDesktop ? 6 : 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 20 : 10),
          SizedBox(
            height: isDesktop ? 350 : 220,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(26),
                    tooltipPadding: EdgeInsets.all(isDesktop ? 2 : 5),
                    getTooltipItem: (group, _, rod, __) {
                      return BarTooltipItem(
                        '7.5 hrs',
                        GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: isDesktop ? 3 : 12,
                        ),
                      );
                    },
                  ),
                ),
                maxY: 8,
                minY: 0,
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: 7.5,
                        color: const Color(0xFF26A69A),
                        width: isDesktop ? 12 : 20,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 8,
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
                        final weekdays = [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                        ];
                        return Text(
                          weekdays[index.toInt()],
                          style: GoogleFonts.roboto(
                            fontSize: isDesktop ? 6 : 14,
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
            ),
          ),
        ],
      ),
    );
  }
}
