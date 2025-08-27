import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;

  const WeightProgressBar({super.key, required this.progress, required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress to Goal',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box8(context)),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: FixedSizes.box8(context),
                color: progressColor,
                backgroundColor: AppTheme.colors['onSurface']!.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.only(right: FixedSizes.box12(context)),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font12(context),
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
