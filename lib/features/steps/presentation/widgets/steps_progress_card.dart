import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsProgressCard extends StatelessWidget {
  const StepsProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '7500 of 10000 steps walked',
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 18 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.edit, size: 18, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.75,
              color: const Color(0xFF26A69A),
              backgroundColor: Colors.white.withOpacity(0.2),
              minHeight: isDesktop ? 12 : 8,
            ),
          ),
        ],
      ),
    );
  }
}
