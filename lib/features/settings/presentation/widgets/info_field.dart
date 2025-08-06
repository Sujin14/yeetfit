import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/theme.dart';

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
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        keyboardType: keyboardType,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['primaryText'],
        ),
      ),
    );
  }
}
