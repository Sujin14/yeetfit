import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WeightProgressBar extends StatelessWidget {
  const WeightProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress to Goal',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 18.sp : 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: 8.h),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                value: 0.95,
                minHeight: isDesktop ? 12.h : 8.h,
                borderRadius: BorderRadius.circular(10.r),
                color: AppTheme.colors['teal'],
                backgroundColor: AppTheme.colors['onSurface']!.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Text(
                  '95%',
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 14.sp : 12.sp,
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