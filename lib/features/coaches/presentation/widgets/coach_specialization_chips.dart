import 'package:flutter/material.dart';
import 'coach_specialization_chip.dart';

/// Wrapping row of specialization tags. With [maxVisible], the rest collapse
/// into a "+N" chip.
class CoachSpecializationChips extends StatelessWidget {
  final List<String> specializations;
  final int? maxVisible;

  const CoachSpecializationChips({
    super.key,
    required this.specializations,
    this.maxVisible,
  });

  @override
  Widget build(BuildContext context) {
    final limit = maxVisible;
    final visible = limit == null
        ? specializations
        : specializations.take(limit).toList();
    final hiddenCount = specializations.length - visible.length;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final specialization in visible)
          CoachSpecializationChip(label: specialization),
        if (hiddenCount > 0) CoachSpecializationChip(label: '+$hiddenCount'),
      ],
    );
  }
}
