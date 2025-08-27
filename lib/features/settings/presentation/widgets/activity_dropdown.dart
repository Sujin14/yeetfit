import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';

class ActivityDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const ActivityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const activityLevels = [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ];

    return ListTile(
      leading: Icon(Icons.directions_run, color: AppTheme.colors['primaryText']),
      title: DropdownButtonFormField<String>(
        value: value != null && activityLevels.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: 'Daily Activity Level',
          labelStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        items: activityLevels
            .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
            .toList(),
        onChanged: onChanged,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
        ),
        validator: UserInfoValidators.validateActivityLevel,
      ),
    );
  }
}