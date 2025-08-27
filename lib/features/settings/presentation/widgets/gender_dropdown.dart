import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';

class GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const GenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.transgender, color: AppTheme.colors['primaryText']),
      title: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font14(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FixedSizes.radius8(context)),
          ),
        ),
        items: ['Male', 'Female']
            .map(
              (gender) => DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                    fontSize: FixedSizes.font14(context),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
          fontSize: FixedSizes.font14(context),
        ),
        validator: UserInfoValidators.validateGender,
      ),
    );
  }
}
