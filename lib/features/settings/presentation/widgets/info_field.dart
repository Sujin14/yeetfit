import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';

class InfoField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const InfoField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.colors['primaryText']),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font14(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FixedSizes.radius8(context)),
          ),
        ),
        keyboardType: keyboardType,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
          fontSize: FixedSizes.font14(context),
        ),
        validator: (value) {
          if (label == 'Name') return UserInfoValidators.validateName(value);
          if (label == 'Age') return UserInfoValidators.validateAge(value);
          if (label == 'Height (cm)') return UserInfoValidators.validateHeight(value);
          if (label.contains('Weight')) return UserInfoValidators.validateWeight(value);
          return null;
        },
      ),
    );
  }
}
