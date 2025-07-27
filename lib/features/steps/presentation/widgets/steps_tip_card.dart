import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsTipCard extends StatelessWidget {
  const StepsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      padding: EdgeInsets.all(isDesktop ? 20.w : 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Tip',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16.sp : 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Weighted vests can make your walks more effective. Use one that’s only 5–10% of your body weight for safety and comfort.',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 13.sp : 11.sp,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}