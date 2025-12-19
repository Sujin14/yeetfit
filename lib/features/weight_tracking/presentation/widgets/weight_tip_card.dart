import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

/// Tip card for weight tracking advice.
class WeightTipCard extends StatelessWidget {
  const WeightTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Loss Tip',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Consistency is key! Track your weight weekly and focus on sustainable habits like balanced nutrition and regular exercise.',
            style: GoogleFonts.roboto(
              fontSize: 11.sp,
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}