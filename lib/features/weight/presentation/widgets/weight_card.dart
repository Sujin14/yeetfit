import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';


class WeightCard extends StatelessWidget {
  final String title;
  final double weight;

  const WeightCard({
    super.key,
    required this.title,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(12.w),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: isDesktop ? 18.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['onSurface'],
          ),
        ),
        trailing: Text(
          '$weight kg',
          style: GoogleFonts.roboto(
            fontSize: isDesktop ? 18.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['indigo'],
          ),
        ),
      ),
    );
  }
}