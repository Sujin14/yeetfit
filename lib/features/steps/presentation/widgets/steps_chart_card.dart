import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsChartCard extends StatelessWidget {
  const StepsChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: EdgeInsets.all(isDesktop ? 24 : 12),
      child: SizedBox(
        height: isDesktop ? 300 : 250,
        child: BarChart(
          BarChartData(
            maxY: 10000,
            barGroups: List.generate(7, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: 7500,
                    width: isDesktop ? 20 : 12,
                    color: const Color(0xFF26A69A),
                    borderRadius: BorderRadius.circular(isDesktop ? 10 : 6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 10000,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        days[value.toInt()],
                        style: GoogleFonts.roboto(
                          fontSize: isDesktop ? 14 : 10,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5000,
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, _, rod, __) {
                  return BarTooltipItem(
                    '7500 👟',
                    GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: isDesktop ? 8 : 10,
                    ),
                  );
                },
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}