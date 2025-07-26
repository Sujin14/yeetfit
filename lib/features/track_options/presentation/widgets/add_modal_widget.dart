import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/drag_handle.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'track_button.dart';

class AddModalWidget extends StatelessWidget {
  const AddModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['lightBackground']!,
      padding: EdgeInsets.all(16.w),
      borderRadius: 24.r,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DragHandle(),
            Text(
              'Track Your Progress',
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['primarytext'],
              ),
            ),
            SizedBox(height: 24.h),
            trackButton(
              context,
              icon: Icons.local_dining,
              label: 'Add Meal',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/food'),
            ),
            SizedBox(height: 12.h),
            trackButton(
              context,
              icon: Icons.bed,
              label: 'Add Sleep',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/sleep'),
            ),
            SizedBox(height: 12.h),
            trackButton(
              context,
              icon: Icons.directions_walk,
              label: 'Add Steps',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/steps'),
            ),
            SizedBox(height: 12.h),
            trackButton(
              context,
              icon: Icons.water_drop,
              label: 'Add Water',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/water'),
            ),
            SizedBox(height: 12.h),
            trackButton(
              context,
              icon: Icons.scale,
              label: 'Add Weight',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/weight'),
            ),
          ],
        ),
      ),
    );
  }
}
