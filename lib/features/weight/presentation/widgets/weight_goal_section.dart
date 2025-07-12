import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';


class WeightGoalSection extends StatelessWidget {
  const WeightGoalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['teal']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Goal',
                style: GoogleFonts.roboto(
                  fontSize: isDesktop ? 20.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors['onSurface'],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.colors['onSurface'], size: 20.sp),
                onPressed: () {},
                tooltip: 'Edit Goal',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Target: 70.0 kg by Dec 2025',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 16.sp : 14.sp,
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}