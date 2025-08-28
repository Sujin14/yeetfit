import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';

class InfoField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const InfoField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.colors['primaryIcon']),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        keyboardType: keyboardType,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
        ),
        validator: label == 'Name'
            ? UserInfoValidators.validateName
            : label == 'Age'
                ? UserInfoValidators.validateAge
                : label == 'Height (cm)'
                    ? UserInfoValidators.validateHeight
                    : UserInfoValidators.validateWeight,
      ),
    );
  }
}