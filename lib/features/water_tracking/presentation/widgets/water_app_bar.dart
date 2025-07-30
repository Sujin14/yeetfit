import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';

class WaterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon:Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => context.go('/user-dashboard'),),
      title: Text(
        'Water Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}