import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SessionDurationSelector extends StatelessWidget {
  static const List<int> options = [30, 45, 60, 90];

  final int selected;
  final ValueChanged<int> onSelected;

  const SessionDurationSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final minutes in options) ...[
          if (minutes != options.first) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GradientSelectChip(
              label: '$minutes min',
              isSelected: minutes == selected,
              height: 44,
              borderRadius: 14,
              padding: EdgeInsets.zero,
              onTap: () => onSelected(minutes),
            ),
          ),
        ],
      ],
    );
  }
}
