import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class StepsTrackingModeToggle extends StatelessWidget {
  final bool isPedometerActive;
  final ValueChanged<bool> onToggle;

  const StepsTrackingModeToggle({
    super.key,
    required this.isPedometerActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Step Tracking Mode',
          style: AppTheme.textStyles['subheading']!.copyWith(
            fontSize: isDesktop ? 16.sp : 18.sp,
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        Switch(
          value: isPedometerActive,
          onChanged: onToggle,
          activeColor: AppTheme.colors['primaryButton'],
        ),
      ],
    );
  }
}
