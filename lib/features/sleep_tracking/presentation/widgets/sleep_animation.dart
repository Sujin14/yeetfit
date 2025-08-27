import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/fixed_sizes.dart';

class SleepAnimation extends StatelessWidget {
  const SleepAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = FixedSizes.box240(context);
    return SizedBox(
      height: size,
      width: size,
      child: Lottie.asset(
        'assets/animations/sleeping.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
