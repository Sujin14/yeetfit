import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Animated steps icon for screen header.
class StepsAnimation extends StatelessWidget {
  const StepsAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Lottie.asset(
        'assets/animations/running.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
