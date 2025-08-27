import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsCaloriesCard extends StatelessWidget {
  final int steps;
  final double calories;

  const StepsCaloriesCard({super.key, required this.steps, required this.calories});

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Steps',
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font14(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
                SizedBox(height: FixedSizes.box6(context)),
                Text(
                  steps.toString(),
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font18(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['teal'],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Calories',
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font14(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
                SizedBox(height: FixedSizes.box6(context)),
                Text(
                  calories.toStringAsFixed(1),
                  style: GoogleFonts.roboto(
                    fontSize: FixedSizes.font18(context),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['indigo'],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
