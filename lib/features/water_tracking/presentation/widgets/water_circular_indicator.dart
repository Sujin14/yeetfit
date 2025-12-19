import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

// Circular progress indicator for water intake.
class WaterCircularIndicator extends StatelessWidget {
  final double progress;

  const WaterCircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160.w,
                height: 160.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 160.w,
                height: 160.h,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20.w,
                  backgroundColor: AppTheme.colors['white']?.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(
                    AppTheme.colors['aquaBlue'],
                  ),
                ),
              ),
              GlassmorphicContainer(
                color: AppTheme.colors['teal']!,
                padding: EdgeInsets.zero,
                borderRadius: 40.r,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 40.sp,
                    color: AppTheme.colors['aquaBlue'],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            '1 Glass = 250 ml',
            style: TextStyle(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
