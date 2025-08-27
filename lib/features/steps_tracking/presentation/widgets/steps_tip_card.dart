import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsTipCard extends StatelessWidget {
  const StepsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Tip',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: FixedSizes.font16(context),
              color: AppTheme.colors['primaryText']!.withOpacity(0.9),
            ),
          ),
          SizedBox(height: FixedSizes.box6(context)),
          Text(
            'Weighted vests can make your walks more effective. Use one that’s only 5–10% of your body weight for safety and comfort.',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font10(context),
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
