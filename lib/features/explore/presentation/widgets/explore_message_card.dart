import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/empty_state_image.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Illustration and message for Explore plan empty states (no container).
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
      padding: const EdgeInsets.fromLTRB(20, AppSpacing.xl, 20, 6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
