import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Diagonal three-stop gradient behind the app shell and its drawer.
class ShellGradientBackground extends StatelessWidget {
  final Widget child;

  const ShellGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            colors.gradientStart,
            colors.gradientMid,
            colors.gradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}
