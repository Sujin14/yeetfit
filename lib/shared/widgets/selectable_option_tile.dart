import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Full-width single-choice option; selection shows a gradient left edge
/// and a primary-tinted icon.
class SelectableOptionTile extends StatelessWidget {
  static const double _height = 60;
  static const double _radius = 16;

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Semantics(
      selected: isSelected,
      button: true,
      child: GlassCard(
        borderRadius: _radius,
        opacity: isSelected ? 0.18 : 0.08,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: _height,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [colors.primary, colors.secondary],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Icon(
                    icon,
                    size: 24,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: colors.primary,
                    ),
                  const SizedBox(width: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
