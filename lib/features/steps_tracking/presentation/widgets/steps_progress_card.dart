import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsProgressCard extends StatelessWidget {
  final int steps;
  final int goal;

  const StepsProgressCard({super.key, required this.steps, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(
        horizontal: FixedSizes.spacing(context),
        vertical: FixedSizes.box8(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(FixedSizes.spacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Steps Progress',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font16(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['onSurface'],
              ),
            ),
            SizedBox(height: FixedSizes.box8(context)),
            LinearProgressIndicator(
              value: progress,
              minHeight: FixedSizes.box12(context),
              backgroundColor: AppTheme.colors['lightBackground'],
              color: AppTheme.colors['teal'],
            ),
            SizedBox(height: FixedSizes.box8(context)),
            Text(
              '$steps / $goal steps',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['onSurface']!.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
