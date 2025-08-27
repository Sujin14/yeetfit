import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class SleepTipsCard extends StatelessWidget {
  const SleepTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(isDesktop ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips to Sleep Better',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: FixedSizes.font16(context),
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box6(context)),
          Text(
            'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
