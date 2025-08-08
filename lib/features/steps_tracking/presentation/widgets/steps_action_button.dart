import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class StepsActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StepsActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
      onPressed: onPressed,
      child: Icon(Icons.add, size: 22.sp, color: AppTheme.colors['onSurface']),
    );
  }
}
