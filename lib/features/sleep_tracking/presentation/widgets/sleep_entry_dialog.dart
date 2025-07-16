import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepEntryDialog extends StatelessWidget {
  const SleepEntryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Add Sleep Entry',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Bed Time',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: Text(
                '10:00 PM',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Wake Up Time',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: Text(
                '06:00 AM',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
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
            child: Text('Add', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
