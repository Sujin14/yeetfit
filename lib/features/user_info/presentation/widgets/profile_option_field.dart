import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/selectable_option_tile.dart';
import '../utils/profile_options.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Single-choice list of [SelectableOptionTile]s as a form field.
class ProfileOptionField extends StatelessWidget {
  final List<ProfileOption> options;
  final String? initialValue;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;

  const ProfileOptionField({
    super.key,
    required this.options,
    required this.initialValue,
    required this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in options) ...[
            SelectableOptionTile(
              icon: option.icon,
              label: option.label,
              isSelected: field.value == option.value,
              onTap: () {
                field.didChange(option.value);
                onChanged(option.value);
              },
            ),
            if (option != options.last) const SizedBox(height: 10),
          ],
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.smd),
              child: Text(
                field.errorText!,
                textAlign: TextAlign.center,
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
