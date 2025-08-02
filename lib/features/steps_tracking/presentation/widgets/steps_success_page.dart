import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../shared/theme/theme.dart';

class StepsSuccessPage extends StatelessWidget {
  final String goal;

  const StepsSuccessPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors['background'],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
            repeat: false,
          ),
          Text(
            'Congratulations! 🎉',
            style: GoogleFonts.roboto(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['teal'],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'You reached your step goal of $goal steps — keep moving! 🚶',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                color: AppTheme.colors['primaryText'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['navBarActive'],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
