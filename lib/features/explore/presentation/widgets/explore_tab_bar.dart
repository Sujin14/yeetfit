import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/explore_provider.dart';

/// Two-segment glass control for Diet / Workouts on Explore.
class ExploreTabBar extends StatelessWidget {
  final ExploreTab selected;
  final ValueChanged<ExploreTab> onSelected;

  const ExploreTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.sm,
      ),
      child: GlassCard(
        borderRadius: 24,
        opacity: 0.1,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                label: 'Diet',
                isSelected: selected == ExploreTab.diet,
                onTap: () => onSelected(ExploreTab.diet),
              ),
            ),
            Expanded(
              child: _Segment(
                label: 'Workouts',
                isSelected: selected == ExploreTab.workout,
                onTap: () => onSelected(ExploreTab.workout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: isSelected ? colors.onPrimary : colors.textSecondary,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.smd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.primary, colors.secondary],
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(label, style: textStyle),
        ),
      ),
    );
  }
}
