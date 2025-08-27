import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightCard extends StatelessWidget {
  final String title;
  final double weight;
  final String? date;

  const WeightCard({super.key, required this.title, required this.weight, this.date});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(FixedSizes.box12(context)),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: FixedSizes.font16(context),
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['onSurface'],
          ),
        ),
        subtitle: date != null
            ? Text(
                'Updated: $date',
                style: GoogleFonts.roboto(
                  fontSize: FixedSizes.font12(context),
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                ),
              )
            : null,
        trailing: Text(
          '${weight.toStringAsFixed(1)} kg',
          style: GoogleFonts.roboto(
            fontSize: FixedSizes.font16(context),
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['indigo'],
          ),
        ),
      ),
    );
  }
}
