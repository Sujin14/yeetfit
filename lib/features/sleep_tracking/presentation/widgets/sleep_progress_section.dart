import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepProgressSection extends StatelessWidget {
  const SleepProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '7.5h of 8.0h',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 12 : 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {},
                tooltip: 'Set Sleep Goal',
              ),
            ],
          ),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(25),
            value: 0.9375,
            minHeight: isDesktop ? 16 : 10,
            color: const Color(0xFF26A69A),
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
