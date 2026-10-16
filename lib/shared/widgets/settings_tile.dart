import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'button_spinner.dart';
import 'glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// 56px glass navigation row: icon | label | chevron. Pass [color] for
/// destructive rows (it tints the icon and label).
class SettingsTile extends StatelessWidget {
  static const double _height = 56;
  static const double _radius = 16;

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final IconData trailingIcon;
  final bool isLoading;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.trailingIcon = Icons.chevron_right,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.xs,
      ),
      child: GlassCard(
        borderRadius: _radius,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            child: SizedBox(
              height: _height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(icon, size: 24, color: color ?? colors.textSecondary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(color: color ?? colors.onBackground),
                      ),
                    ),
                    if (isLoading)
                      ButtonSpinner(color: color ?? colors.primary)
                    else
                      Icon(trailingIcon, size: 20, color: colors.textMuted),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
