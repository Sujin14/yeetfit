import 'package:flutter/material.dart';
import '../../domain/entities/progress_metric.dart';
import 'metric_filter_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Horizontally scrolling metric chips for the Progress calendar.
class MetricFilterRow extends StatelessWidget {
  final ProgressMetric selected;
  final ValueChanged<ProgressMetric> onSelected;

  const MetricFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static IconData _iconFor(ProgressMetric metric) => switch (metric) {
    ProgressMetric.all => Icons.apps_rounded,
    ProgressMetric.steps => Icons.directions_walk,
    ProgressMetric.water => Icons.water_drop_outlined,
    ProgressMetric.sleep => Icons.bedtime_outlined,
    ProgressMetric.calories => Icons.local_fire_department_outlined,
    ProgressMetric.mood => Icons.mood,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Row(
        children: [
          // Reserved for sorting options.
          const MetricFilterChip(icon: Icons.tune_rounded),
          for (final metric in ProgressMetric.values)
            MetricFilterChip(
              icon: _iconFor(metric),
              label: metric.label,
              isSelected: metric == selected,
              onTap: () => onSelected(metric),
            ),
        ],
      ),
    );
  }
}
