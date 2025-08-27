import 'package:fl_chart/fl_chart.dart' as charts;
import 'package:flutter/material.dart';

import '../../../../utils/fixed_sizes.dart';


class StepsChartSection extends StatelessWidget {
  final List<charts.BarChartGroupData> barGroups;
  final bool animate;

  const StepsChartSection({
    super.key,
    required this.barGroups,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FixedSizes.box240(context),
      child: charts.BarChart(
        charts.BarChartData(
          barGroups: barGroups,
        ),
        swapAnimationDuration: animate ? const Duration(milliseconds: 250) : Duration.zero,
      ),
    );
  }
}
