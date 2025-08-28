import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class StepsActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StepsActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppTheme.colors['primaryButton']!.withOpacity(0.8),
      onPressed: onPressed,
      child: Icon(
        Icons.add,
        size: 22.sp,
        color: AppTheme.colors['onSurfaceDark'],
      ),
    );
  }
}
