import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class SleepAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SleepAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppTheme.colors['primaryIcon'],
          size: 24.sp,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Sleep Tracking',
        style: AppTheme.textStyles['subheading']!.copyWith(
          color: AppTheme.colors['primaryText'],
          fontSize: 20.sp,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: AppTheme.colors['primaryIcon'],
            size: 24.sp,
          ),
          onPressed: () {
            context.push('/settings');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}