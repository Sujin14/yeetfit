import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class ProgressHeader extends StatelessWidget {
  final ValueChanged<String?> onMetricChanged;

  const ProgressHeader({super.key, required this.onMetricChanged});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: EdgeInsets.all(isDesktop ? 20.w : 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress Heatmap',
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          DropdownButton<String>(
            value: 'All Metrics',
            dropdownColor: AppTheme.colors['indigo']!.withOpacity(0.5),
            style: GoogleFonts.roboto(
              color: AppTheme.colors['primaryText'],
              fontSize: isDesktop ? 16.sp : 14.sp,
            ),
            icon: Icon(Icons.arrow_drop_down, color: AppTheme.colors['primaryText'],),
            underline: const SizedBox(),
            onChanged: onMetricChanged,
            items: [
              DropdownMenuItem(
                value: 'All Metrics',
                child: Text('All Metrics', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
              DropdownMenuItem(
                value: 'Meal Tracking',
                child: Text('Meal Tracking', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
              DropdownMenuItem(
                value: 'Sleep',
                child: Text('Sleep', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
              DropdownMenuItem(
                value: 'Steps',
                child: Text('Steps', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
              DropdownMenuItem(
                value: 'Water',
                child: Text('Water', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
              DropdownMenuItem(
                value: 'Weight',
                child: Text('Weight', style: TextStyle(color: AppTheme.colors['primaryText'],)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}