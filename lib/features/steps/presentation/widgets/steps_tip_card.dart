import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsTipCard extends StatelessWidget {
  const StepsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      padding: EdgeInsets.all(isDesktop ? 20 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Tip',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16 : 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Weighted vests can make your walks more effective. Use one that’s only 5–10% of your body weight for safety and comfort.',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 13 : 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
