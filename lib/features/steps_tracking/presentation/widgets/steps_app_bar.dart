import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';

class StepsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StepsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Steps Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}