import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class AddModalWidget extends StatelessWidget {
  const AddModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['primaryAccent']!,
      padding: EdgeInsets.all(16.w),
      borderRadius: 24.r,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Track Your Progress',
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['primarytext'],
              ),
            ),
            SizedBox(height: 24.h),
            _buildTrackButton(
              context,
              icon: Icons.local_dining,
              label: 'Add Meal',
              color: AppTheme.colors['deepOrange'] ?? Colors.orange,
              onPressed: () => context.push('/modal/food'),
            ),
            SizedBox(height: 12.h),
            _buildTrackButton(
              context,
              icon: Icons.bed,
              label: 'Add Sleep',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/sleep'),
            ),
            SizedBox(height: 12.h),
            _buildTrackButton(
              context,
              icon: Icons.directions_walk,
              label: 'Add Steps',
              color: AppTheme.colors['deepOrange'] ?? Colors.orange,
              onPressed: () => context.push('/modal/steps'),
            ),
            SizedBox(height: 12.h),
            _buildTrackButton(
              context,
              icon: Icons.water_drop,
              label: 'Add Water',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/water'),
            ),
            SizedBox(height: 12.h),
            _buildTrackButton(
              context,
              icon: Icons.scale,
              label: 'Add Weight',
              color: AppTheme.colors['deepOrange'] ?? Colors.orange,
              onPressed: () => context.push('/modal/weight'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final isDesktop = MediaQuery.of(context).size.width >= 600.w;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final onSurfaceColor = isDarkTheme
        ? AppTheme.colors['onSurfaceDark'] ?? Colors.white
        : AppTheme.colors['onSurface'] ?? Colors.black;

    return GlassmorphicContainer(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      borderRadius: 16.r,
      child: ListTile(
        leading: Icon(
          icon,
          color: onSurfaceColor,
          size: isDesktop ? 28.sp : 24.sp,
        ),
        title: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: isDesktop ? 18.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
