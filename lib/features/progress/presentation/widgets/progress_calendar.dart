import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ProgressCalendar extends StatelessWidget {
  final Map<DateTime, int> dataset;
  final Color baseColor;

  const ProgressCalendar({
    super.key,
    required this.dataset,
    this.baseColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    if (dataset.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final normalizedDataset = dataset.map((date, value) {
      final safeValue = value < 0 ? 0 : value;
      return MapEntry(date, safeValue);
    });

    final hasNonZero = normalizedDataset.values.any((v) => v > 0);
    final safeDataset = hasNonZero ? normalizedDataset : {DateTime.now(): 1};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: HeatMapCalendar(
        datasets: safeDataset,
        colorMode: ColorMode.opacity,
        colorsets: {1: baseColor},
        showColorTip: true,
        monthFontSize: 16,
        weekFontSize: 12,
        textColor: Colors.black,
        defaultColor: Colors.grey[200]!,
        size: 32,
        margin: const EdgeInsets.all(4),
        onClick: (date) {},
      ),
    );
  }
}
