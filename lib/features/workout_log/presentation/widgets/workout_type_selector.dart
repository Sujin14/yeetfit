import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import '../../domain/entities/workout_type.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WorkoutTypeSelector extends StatelessWidget {
  final WorkoutType? selected;
  final ValueChanged<WorkoutType> onSelected;

  const WorkoutTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final type in WorkoutType.values)
          GradientSelectChip(
            label: type.label,
            isSelected: type == selected,
            onTap: () => onSelected(type),
          ),
      ],
    );
  }
}
