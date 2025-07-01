import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Progress Tracking Coming Soon!',
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: 18.sp,
          color: AppTheme.colors['primaryText'],
        ),
      ),
    );
  }
}
