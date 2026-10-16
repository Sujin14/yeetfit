import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/number_picker.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// [NumberPicker] wired into the step's [Form] so the existing
/// save/validate flow keeps working unchanged.
class NumberPickerField extends StatelessWidget {
  final double initialValue;
  final double min;
  final double max;
  final double step;
  final int fractionDigits;
  final String? unit;
  final String? label;
  final FormFieldValidator<double> validator;
  final FormFieldSetter<double> onSaved;

  const NumberPickerField({
    super.key,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.validator,
    required this.onSaved,
    this.step = 1,
    this.fractionDigits = 0,
    this.unit,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return FormField<double>(
      initialValue: initialValue.clamp(min, max),
      validator: validator,
      onSaved: onSaved,
      builder: (field) => Column(
        children: [
          NumberPicker(
            value: field.value ?? initialValue,
            min: min,
            max: max,
            step: step,
            fractionDigits: fractionDigits,
            unit: unit,
            label: label,
            onChanged: field.didChange,
          ),
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.smd),
              child: Text(
                field.errorText!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: colors.error),
              ),
            ),
        ],
      ),
    );
  }
}
