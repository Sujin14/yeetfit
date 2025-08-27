import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsAnimation extends StatelessWidget {
  const StepsAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FixedSizes.box200(context),
      child: Lottie.asset(
        'assets/animations/running.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
