import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/model/sleep_model.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_chart_shimmer.dart';

class SleepChartSection extends ConsumerWidget {
  final String userId;
  const SleepChartSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyDataAsync = ref.watch(weeklySleepDataProvider(userId));

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: FixedSizes.font20(context),
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box10(context)),
          SizedBox(
            height: FixedSizes.box220(context),
            child: weeklyDataAsync.when(
              data: (weeklyData) => _buildBarChart(context, ref, weeklyData),
              loading: () => const SleepChartShimmer(),
              error: (e, _) => Text(
                'Error: $e',
                style: TextStyle(color: AppTheme.colors['white']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, WidgetRef ref, List<SleepData> weeklyData) {
    final maxGoal = weeklyData.map((d) => d.goalHours).fold<double>(0.0, (a, b) => a > b ? a : b);
    final interval = maxGoal <= 10 ? 2.0 : 4.0;

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0,
            fitInsideHorizontally: true,
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
                  color: AppTheme.colors['white'],
                  fontSize: FixedSizes.font12(context),
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        maxY: maxGoal < 10 ? 10 : (maxGoal + 2),
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
                toY: data.duration.clamp(0.0, data.goalHours),
                color: progressColor,
                width: FixedSizes.box20(context),
                borderRadius: BorderRadius.circular(FixedSizes.radius8(context)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: data.goalHours,
                  color: AppTheme.colors['primaryText']!.withOpacity(0.2),
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
              interval: interval,
              reservedSize: FixedSizes.box30(context),
              getTitlesWidget: (value, _) => Padding(
                padding: EdgeInsets.only(right: FixedSizes.box4(context)),
                child: Text(
                  value.toInt().toString(),
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font12(context),
                    color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: FixedSizes.box30(context),
              getTitlesWidget: (index, _) {
                final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                return Text(
                  weekdays[index.toInt()],
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font14(context),
                    color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
