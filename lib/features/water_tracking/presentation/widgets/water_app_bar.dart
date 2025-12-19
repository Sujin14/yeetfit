import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/shell_route_constants.dart';
import '../../../../shared/theme/theme.dart';

// Custom AppBar for water tracking.
class WaterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.colors['onSurface']),
        onPressed: () => context.go(ShellRouteConstants.dashboard),
      ),
      title: Text(
        'Water Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
