import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/theme.dart';

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
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        items: ['Male', 'Female']
            .map(
              (gender) => DropdownMenuItem(value: gender, child: Text(gender)),
            )
            .toList(),
        onChanged: onChanged,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
        ),
      ),
    );
  }
}
