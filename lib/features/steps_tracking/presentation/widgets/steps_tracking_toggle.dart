import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsTrackingModeToggle extends StatelessWidget {
  final bool isPedometerActive;
  final ValueChanged<bool> onToggle;

  const StepsTrackingModeToggle({
    super.key,
    required this.isPedometerActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Step Tracking Mode',
          style: GoogleFonts.roboto(
            fontSize: FixedSizes.font16(context),
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['onSurface'],
          ),
        ),
        Switch(
          value: isPedometerActive,
          onChanged: onToggle,
          activeColor: AppTheme.colors['teal'],
        ),
      ],
    );
  }
}
