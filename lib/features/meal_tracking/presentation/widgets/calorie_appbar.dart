import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';

class CalorieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalorieAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      title: Text(
          "Meal Tracking",
          style: GoogleFonts.roboto(
            color: AppTheme.colors['onSurface'],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
    );
  }
}
