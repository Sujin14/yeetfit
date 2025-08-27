import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class WaterTipCard extends StatelessWidget {
  const WaterTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive']!,
      child: Padding(
        padding: EdgeInsets.all(FixedSizes.box16(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Tip',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: FixedSizes.font16(context),
                color: AppTheme.colors['primaryText']?.withOpacity(0.8),
              ),
            ),
            SizedBox(height: FixedSizes.box6(context)),
            Text(
              'Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['primaryText']?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
