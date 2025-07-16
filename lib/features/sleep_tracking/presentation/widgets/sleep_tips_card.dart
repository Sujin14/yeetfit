import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepTipsCard extends StatelessWidget {
  const SleepTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      padding: EdgeInsets.all(isDesktop ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips to Sleep Better',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 5 : 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 4 : 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}