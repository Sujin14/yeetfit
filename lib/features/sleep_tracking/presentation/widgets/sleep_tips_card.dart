import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

// Tip card for sleep advice.
class SleepTipsCard extends StatelessWidget {
  const SleepTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(isDesktop ? 8.w : 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips to Sleep Better',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 5.sp : 18.sp,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 4.sp : 14.sp,
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}