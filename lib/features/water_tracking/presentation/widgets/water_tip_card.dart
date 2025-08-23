import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterTipCard extends StatelessWidget {
  const WaterTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive'] ?? Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Tip',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppTheme.colors['primaryText']?.withOpacity(0.8) ?? Colors.grey,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: AppTheme.colors['primaryText']?.withOpacity(0.6) ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}