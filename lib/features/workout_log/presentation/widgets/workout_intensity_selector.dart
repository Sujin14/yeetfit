import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import '../../domain/entities/workout_intensity.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WorkoutIntensitySelector extends StatelessWidget {
  final WorkoutIntensity selected;
  final ValueChanged<WorkoutIntensity> onSelected;

  const WorkoutIntensitySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, intensity) in WorkoutIntensity.values.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GradientSelectChip(
              label: intensity.label,
              isSelected: intensity == selected,
              height: 44,
              onTap: () => onSelected(intensity),
            ),
          ),
        ],
      ],
    );
  }
}
