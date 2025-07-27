import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WeightChartSection extends ConsumerWidget {
  final String userId;

  const WeightChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('WeightChartSection: Building for userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    final weeklyDataAsync = ref.watch(weeklyWeightDataProvider(userId));

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Trend',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: weeklyDataAsync.when(
              data: (weeklyData) {
                print('WeightChartSection: weeklyData for userId=$userId, entries=${weeklyData.length}');
                final minWeight = weeklyData.isNotEmpty
                    ? weeklyData.map((e) => e.currentWeight).reduce((a, b) => a < b ? a : b) - 5
                    : 65.0;
                final maxWeight = weeklyData.isNotEmpty
                    ? weeklyData.map((e) => e.currentWeight).reduce((a, b) => a > b ? a : b) + 5
                    : 80.0;
                print('WeightChartSection: minWeight=$minWeight, maxWeight=$maxWeight for userId=$userId');
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
                          reservedSize: 30.h,
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                date.day.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
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
                          reservedSize: 40.w,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()} kg',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: AppTheme.colors['onSurface'],
                              ),
                            );
                          },
                          interval: 5,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(weeklyData.length, (index) {
                          print('WeightChartSection: Plotting point $index: currentWeight=${weeklyData[index].currentWeight} for userId=$userId');
                          return FlSpot(index.toDouble(), weeklyData[index].currentWeight);
                        }),
                        isCurved: true,
                        color: AppTheme.colors['teal'],
                        barWidth: 4,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.colors['teal']!.withOpacity(0.2),
                        ),
                      ),
                    ],
                    minY: minWeight,
                    maxY: maxWeight,
                  ),
                );
              },
              loading: () {
                print('WeightChartSection: Loading weekly data for userId=$userId');
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, _) {
                print('WeightChartSection: Error loading weekly data for userId=$userId: $error');
                return Text('Error: $error', style: TextStyle(color: AppTheme.colors['onSurface']));
              },
            ),
          ),
        ],
      ),
    );
  }
}