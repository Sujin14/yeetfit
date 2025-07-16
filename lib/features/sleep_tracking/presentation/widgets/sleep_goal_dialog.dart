import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepGoalDialog extends StatelessWidget {
  const SleepGoalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Set Sleep Goal (hours)',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: GoogleFonts.roboto(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A).withOpacity(0.3),
            ),
            child: Text('Save', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
