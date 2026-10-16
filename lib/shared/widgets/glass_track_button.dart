import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Gradient "+" circle at the center of [GlassBottomNavBar].
class GlassTrackButton extends StatelessWidget {
  final double diameter;
  final VoidCallback onTap;

  const GlassTrackButton({
    super.key,
    required this.diameter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      button: true,
      label: 'Track',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.secondary, colors.primaryVariant],
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.55),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
