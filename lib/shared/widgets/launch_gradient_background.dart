import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Two-stop diagonal gradient behind the pre-auth screens
/// (splash, welcome, onboarding).
class LaunchGradientBackground extends StatelessWidget {
  final Widget child;

  const LaunchGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: child,
    );
  }
}
