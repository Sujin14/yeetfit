import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Water Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}