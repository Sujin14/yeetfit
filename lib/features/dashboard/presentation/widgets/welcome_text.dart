import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class WelcomeText extends StatelessWidget {
  final String name;

  const WelcomeText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome, $name!',
      style: AppTheme.textStyles['heading']!.copyWith(
        fontSize: 28.sp,
        color: AppTheme.colors['primaryText']!.withOpacity(0.9),
      ),
    );
  }
}