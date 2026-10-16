import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Verified mark: a bare icon in lists, an icon with a label on the detail
/// screen.
class CoachVerifiedBadge extends StatelessWidget {
  final bool showLabel;

  const CoachVerifiedBadge({super.key, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final icon = Icon(
      Icons.verified_rounded,
      size: showLabel ? 16 : 18,
      color: colors.secondary,
    );
    if (!showLabel) {
      return Tooltip(message: 'Verified coach', child: icon);
    }
    return GlassCard(
      borderRadius: 10,
      blurStrength: 8,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Verified coach',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 12,
              color: colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
