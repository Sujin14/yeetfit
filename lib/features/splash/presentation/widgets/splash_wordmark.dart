import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "Yeetfit" title and tagline, always light over the splash artwork.
class SplashWordmark extends StatelessWidget {
  const SplashWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Yeetfit',
          style: textTheme.displayMedium!.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your fitness, tracked.',
          style: textTheme.bodyLarge!.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
