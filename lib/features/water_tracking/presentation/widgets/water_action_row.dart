import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Remove (glass circle) and add (gradient circle) glass buttons.
class WaterActionRow extends StatelessWidget {
  static const double _removeSize = 56;
  static const double _addSize = 68;

  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WaterActionRow({
    super.key,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: 'Remove glass',
          child: SizedBox.square(
            dimension: _removeSize,
            child: GlassCard(
              borderRadius: _removeSize / 2,
              padding: EdgeInsets.zero,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.remove_rounded,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Tooltip(
          message: 'Add glass',
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onAdd,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: _addSize,
                  child: Icon(
                    Icons.add_rounded,
                    size: 32,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
