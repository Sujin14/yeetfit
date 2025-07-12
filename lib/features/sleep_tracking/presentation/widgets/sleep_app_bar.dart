import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SleepAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Sleep Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {},
          tooltip: 'Add Sleep Entry',
        ),
      ],
    );
  }
}
