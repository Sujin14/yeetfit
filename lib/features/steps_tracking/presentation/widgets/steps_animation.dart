import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class StepsAnimation extends StatelessWidget {
  const StepsAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Lottie.asset(
        'assets/animations/running.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
