import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Tinted glass row in the track options sheet.
class TrackButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TrackButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDesktop = MediaQuery.sizeOf(context).width >= 600;

    return GlassCard(
      color: color,
      opacity: 0.12,
      blurStrength: 10,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      borderRadius: 16,
      border: Border.all(color: color.withValues(alpha: 0.35)),
      child: ListTile(
        leading: Icon(icon, color: color, size: isDesktop ? 28 : 24),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: colors.onBackground,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colors.onBackground.withValues(alpha: 0.6),
        ),
        onTap: onTap,
      ),
    );
  }
}
