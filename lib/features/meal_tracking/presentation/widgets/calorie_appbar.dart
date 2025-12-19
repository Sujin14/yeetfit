import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/shell_route_constants.dart';
import '../../../../shared/theme/theme.dart';

// Custom AppBar for calorie tracking.
class CalorieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalorieAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(ShellRouteConstants.dashboard),
      ),
      title: Text(
        "Meal Tracking",
        style: GoogleFonts.roboto(
          color: AppTheme.colors['onSurface'],
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
