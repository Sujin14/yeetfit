import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';

/// Heart toggle that narrows a plan list to favourites.
class PlanFavoritesToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback onToggle;

  const PlanFavoritesToggle({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GlassIconButton(
      icon: isActive ? Icons.favorite : Icons.favorite_border,
      color: isActive ? colors.error : colors.onBackground,
      tooltip: isActive ? 'Show all plans' : 'Show favourites only',
      onPressed: onToggle,
    );
  }
}
