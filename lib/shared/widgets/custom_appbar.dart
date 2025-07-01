import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogout;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLogout = false,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['navigationAccent']!,
      elevation: 5,
      title: Center(
        child: Text(
          title,
          style: AppTheme.textStyles['title']!.copyWith(
            fontSize: 20.sp,
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: AppTheme.colors['primaryText']),
      actions: [
        if (showLogout)
          IconButton(
            icon: Icon(Icons.logout, color: AppTheme.colors['primaryText']),
            onPressed: onLogout,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
