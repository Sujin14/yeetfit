import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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
        onPressed: () => context.go('/user-dashboard'),
      ),
      title: Text(
        'Water Tracker',
        style: GoogleFonts.roboto(
          fontSize: FixedSizes.font24(context),
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
