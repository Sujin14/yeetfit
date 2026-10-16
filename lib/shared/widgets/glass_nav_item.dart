import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Icon + label tab used inside [GlassBottomNavBar]. Must be placed in a Row.
class GlassNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const GlassNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const double _dotSize = 6;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = isActive
        ? colors.onBackground
        : Colors.white.withValues(alpha: 0.7);
    return Expanded(
      child: Semantics(
        selected: isActive,
        button: true,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isActive ? activeIcon : icon, color: color, size: 24),
              const SizedBox(height: 2),
              // Space is reserved when inactive so labels don't jump.
              Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? colors.primary : Colors.transparent,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 10,
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
