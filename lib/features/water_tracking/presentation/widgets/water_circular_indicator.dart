import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colors['transparent'] ?? Colors.transparent,
                ),
              ),
              SizedBox(
                width: 160.w,
                height: 160.h,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20.w,
                  backgroundColor: AppTheme.colors['white']?.withOpacity(0.5) ?? Colors.white30,
                  valueColor: AlwaysStoppedAnimation(AppTheme.colors['aquaBlue'] ?? Colors.blue),
                ),
              ),
              GlassmorphicContainer(
                color: const Color(0xFF26A69A),
                padding: EdgeInsets.all(0.w),
                borderRadius: 40.r,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 40.sp,
                    color: AppTheme.colors['aquaBlue'] ?? Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            '1 Glass = 250 ml',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7) ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}