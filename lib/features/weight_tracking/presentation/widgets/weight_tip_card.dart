import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightTipCard extends StatelessWidget {
  const WeightTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['green']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Management Tips',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          Text(
            '• Maintain a balanced diet.\n'
            '• Exercise regularly.\n'
            '• Track your weight consistently.\n'
            '• Stay hydrated and sleep well.',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['onSurface']!.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
