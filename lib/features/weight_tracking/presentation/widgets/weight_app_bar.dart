import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/routes/shell_route_constants.dart';
import '../../../../shared/theme/theme.dart';

/// Custom AppBar for weight tracking screen.
class WeightAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const WeightAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      elevation: 2,
      leading: IconButton(
        onPressed: () => context.go(ShellRouteConstants.dashboard),
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: Text(
        'Weight Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}