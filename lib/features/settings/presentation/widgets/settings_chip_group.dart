import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import 'settings_field_label.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Labelled [Wrap] of selectable chips. Selection rules (single vs. multi)
/// live in the caller via [isSelected] / [onTap].
class SettingsChipGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final bool Function(String option) isSelected;
  final ValueChanged<String> onTap;
  final String Function(String option)? labelFor;

  const SettingsChipGroup({
    super.key,
    required this.label,
    required this.options,
    required this.isSelected,
    required this.onTap,
    this.labelFor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsFieldLabel(label),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final option in options)
              GradientSelectChip(
                label: labelFor?.call(option) ?? option,
                isSelected: isSelected(option),
                onTap: () => onTap(option),
              ),
          ],
        ),
      ],
    );
  }
}
