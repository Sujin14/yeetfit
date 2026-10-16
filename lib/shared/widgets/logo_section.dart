import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Logo, wordmark and tagline used on the auth and welcome screens.
class LogoSection extends StatelessWidget {
  final double topPadding;
  final bool showLogo;

  const LogoSection({super.key, this.topPadding = 60, this.showLogo = true});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLogo) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/yeetfit_logo.webp',
                  width: 72,
                  height: 72,
                  cacheWidth: 216,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              'Yeetfit',
              style: textTheme.displayMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your fitness, tracked.',
              style: textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
