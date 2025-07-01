import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Content Coming Soon!',
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: 18.sp,
          color: AppTheme.colors['primaryText'],
        ),
      ),
    );
  }
}
