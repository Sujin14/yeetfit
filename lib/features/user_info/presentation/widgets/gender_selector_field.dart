import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/gradient_select_chip.dart';
import '../../domain/validators/user_info_validators.dart';
import '../utils/profile_options.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Male / Female / Other chips; tapping the selected chip clears it.
class GenderSelectorField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String> onSaved;

  const GenderSelectorField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return FormField<String>(
      initialValue: initialValue,
      validator: UserInfoValidators.validateGender,
      onSaved: onSaved,
      builder: (field) => Column(
        children: [
          Row(
            children: [
              for (final gender in genderOptions) ...[
                Expanded(
                  child: GradientSelectChip(
                    label: gender,
                    height: 56,
                    borderRadius: 16,
                    padding: EdgeInsets.zero,
                    textStyle: textTheme.titleMedium,
                    isSelected: field.value == gender,
                    onTap: () {
                      final next = field.value == gender ? null : gender;
                      field.didChange(next);
                      if (next != null) onChanged(next);
                    },
                  ),
                ),
                if (gender != genderOptions.last) const SizedBox(width: 10),
              ],
            ],
          ),
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.smd),
              child: Text(
                field.errorText!,
                style: textTheme.bodySmall!.copyWith(color: colors.error),
              ),
            ),
        ],
      ),
    );
  }
}
