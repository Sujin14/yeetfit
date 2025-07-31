import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../data/model/steps_model.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsChartCard extends ConsumerWidget {
  final String userId;

  const StepsChartCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklyStepsDataProvider(userId));
    final isDesktop = ScreenUtil().screenWidth >= 600.w;

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(isDesktop ? 24.w : 12.w),
      child: SizedBox(
        height: isDesktop ? 300.h : 250.h,
        child: weeklyDataAsync.when(
          data: (weeklyData) {
            return BarChart(
              BarChartData(
                maxY: 15000,
                minY: 0,
                barGroups: List.generate(7, (index) {
                  final date = DateTime.now().subtract(
                    Duration(days: 6 - index),
                  );
                  final dateString = date.toIso8601String().split('T')[0];
                  final data = weeklyData.firstWhere(
                    (entry) => entry.date == dateString,
                    orElse: () => StepsData(
                      date: dateString,
                      steps: 0,
                      goalSteps: 10000,
                      caloriesBurned: 0.0,
                    ),
                  );
                  final progressColor = ref.watch(
                    dailyStepsProgressColorProvider('$userId|$dateString'),
                  );
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.steps.toDouble(),
                        width: isDesktop ? 20.w : 12.w,
                        color: progressColor,
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 10.r : 6.r,
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: data.goalSteps.toDouble(),
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
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            days[value.toInt()],
                            style: GoogleFonts.roboto(
                              fontSize: isDesktop ? 14.sp : 10.sp,
                              color: AppTheme.colors['primaryText']!
                                  .withOpacity(0.9),
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
                      reservedSize: 40.w,
                    ),
                  ),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, rod, __) {
                      final date = DateTime.now().subtract(
                        Duration(days: 6 - group.x),
                      );
                      final dateString = date.toIso8601String().split('T')[0];
                      final data = weeklyData.firstWhere(
                        (entry) => entry.date == dateString,
                        orElse: () => StepsData(
                          date: dateString,
                          steps: 0,
                          goalSteps: 10000,
                          caloriesBurned: 0.0,
                        ),
                      );
                      return BarTooltipItem(
                        '${data.steps} 👟',
                        GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: isDesktop ? 8.sp : 10.sp,
                        ),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
