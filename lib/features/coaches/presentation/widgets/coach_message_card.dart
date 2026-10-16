import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/empty_state_image.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Empty and no-results states for the coach list, led by either an icon or
/// an illustration.
class CoachMessageCard extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String message;

  const CoachMessageCard({
    super.key,
    this.icon,
    this.imageAsset,
    required this.message,
  }) : assert((icon == null) != (imageAsset == null));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAsset case final asset?)
              EmptyStateImage(assetPath: asset)
            else
              Icon(icon, size: 36, color: colors.textSecondary),
            const SizedBox(height: AppSpacing.smd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: colors.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}
