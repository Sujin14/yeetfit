import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/empty_state_image.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Glass card with an illustration, message and optional action — used for
/// the empty states of the plan list.
class ExploreMessageCard extends StatelessWidget {
  final String imageAsset;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ExploreMessageCard({
    super.key,
    required this.imageAsset,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            EmptyStateImage(assetPath: imageAsset),
            const SizedBox(height: AppSpacing.smd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: TextStyle(color: colors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
