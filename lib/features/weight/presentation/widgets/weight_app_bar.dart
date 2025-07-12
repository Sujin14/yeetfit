import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';

class WeightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeightAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Weight Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: AppTheme.colors['onSurface'],
            size: 20.sp,
          ),
          onPressed: () => context.push('/modal/weight'),
          tooltip: 'Add Weight Entry',
        ),
      ],
    );
  }
}
