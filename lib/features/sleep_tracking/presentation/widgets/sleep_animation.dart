import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

// Animated sleep icon for screen header.
class SleepAnimation extends StatelessWidget {
  const SleepAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 200.w,
      child: Lottie.asset(
        'assets/animations/sleeping.json',
        fit: BoxFit.contain,
      ),
    );
  }
}