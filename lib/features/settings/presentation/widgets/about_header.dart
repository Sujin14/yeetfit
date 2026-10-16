import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AboutHeader extends StatelessWidget {
  static const String _logo = 'assets/images/yeetfit_logo.webp';

  final String versionLabel;

  const AboutHeader({super.key, required this.versionLabel});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              _logo,
              width: 80,
              height: 80,
              cacheWidth: 240,
              errorBuilder: (_, _, _) =>
                  Icon(Icons.fitness_center, size: 80, color: colors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'YeetFit',
            style: textTheme.headlineLarge!.copyWith(
              color: colors.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            versionLabel,
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your personal fitness companion',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
