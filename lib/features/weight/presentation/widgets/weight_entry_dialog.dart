import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';


class WeightEntryDialog extends StatelessWidget {
  const WeightEntryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(16.w),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Add Weight Entry',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 20.sp : 18.sp,
            color: AppTheme.colors['onSurface'],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppTheme.colors['borderGradientStart']!),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.roboto(
                color: AppTheme.colors['onSurface'],
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              title: Text(
                'Date',
                style: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface'],
                  fontSize: isDesktop ? 16.sp : 14.sp,
                ),
              ),
              trailing: Text(
                'Jul 12, 2025',
                style: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface'],
                  fontSize: isDesktop ? 16.sp : 14.sp,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                color: AppTheme.colors['onSurface'],
                fontSize: isDesktop ? 16.sp : 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['teal']!.withOpacity(0.3),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.roboto(
                color: AppTheme.colors['onSurface'],
                fontSize: isDesktop ? 16.sp : 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}