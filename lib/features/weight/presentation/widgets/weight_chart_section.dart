import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class WeightChartSection extends StatelessWidget {
  const WeightChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Trend',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: isDesktop ? 300 : 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                        ];
                        final idx = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            idx >= 0 && idx < labels.length ? labels[idx] : '',
                            style: GoogleFonts.roboto(
                              fontSize: isDesktop ? 14 : 12,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} kg',
                          style: GoogleFonts.roboto(
                            fontSize: isDesktop ? 14 : 12,
                            color: Colors.white,
                          ),
                        );
                      },
                      interval: 5,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 75.0),
                      FlSpot(1, 74.5),
                      FlSpot(2, 73.8),
                      FlSpot(3, 73.0),
                      FlSpot(4, 72.5),
                      FlSpot(5, 72.0),
                      FlSpot(6, 71.5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF26A69A),
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF26A69A).withOpacity(0.2),
                    ),
                  ),
                ],
                minY: 65,
                maxY: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
