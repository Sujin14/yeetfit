import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsCaloriesCard extends StatelessWidget {
  final double caloriesBurned;
  final double goalCalories;

  const StepsCaloriesCard({
    super.key,
    required this.caloriesBurned,
    required this.goalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories Burned',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16.sp : 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Goal:',
                style: GoogleFonts.roboto(
                  fontSize: isDesktop ? 14.sp : 14.sp,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${goalCalories.toStringAsFixed(0)} Cal 🔥',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14.sp : 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Burn:',
                style: GoogleFonts.roboto(
                  fontSize: isDesktop ? 14.sp : 14.sp,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${caloriesBurned.toStringAsFixed(0)} Cal 🔥',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14.sp : 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}