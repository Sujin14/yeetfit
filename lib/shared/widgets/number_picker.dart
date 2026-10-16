import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'glass_circle_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Large numeric readout with − / + glass buttons, clamped to [min]..[max].
class NumberPicker extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final int fractionDigits;
  final String? unit;
  final String? label;
  final ValueChanged<double> onChanged;

  const NumberPicker({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.fractionDigits = 0,
    this.unit,
    this.label,
  });

  // Rounds to the display precision so repeated 0.5 steps don't drift.
  double _normalize(double raw) =>
      double.parse(raw.clamp(min, max).toStringAsFixed(fractionDigits));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final canDecrease = value - step >= min - 1e-9;
    final canIncrease = value + step <= max + 1e-9;
    final display = value.toStringAsFixed(fractionDigits);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.titleMedium!.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Semantics(
          label: label,
          value: unit == null ? display : '$display $unit',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                display,
                style: textTheme.displayLarge!.copyWith(
                  color: colors.onBackground,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 6),
                Text(
                  unit!,
                  style: textTheme.headlineMedium!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassCircleButton(
              icon: Icons.remove_rounded,
              tooltip: 'Decrease',
              onPressed: canDecrease
                  ? () => onChanged(_normalize(value - step))
                  : null,
            ),
            const SizedBox(width: AppSpacing.xl),
            GlassCircleButton(
              icon: Icons.add_rounded,
              tooltip: 'Increase',
              onPressed: canIncrease
                  ? () => onChanged(_normalize(value + step))
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
