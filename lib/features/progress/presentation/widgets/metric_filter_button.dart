import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/progress_metric.dart';

/// Compact filter control for the Progress header; opens a glass dropdown.
class MetricFilterButton extends StatefulWidget {
  final ProgressMetric selected;
  final ValueChanged<ProgressMetric> onSelected;

  const MetricFilterButton({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static IconData iconFor(ProgressMetric metric) => switch (metric) {
    ProgressMetric.all => Icons.apps_rounded,
    ProgressMetric.steps => Icons.directions_walk,
    ProgressMetric.water => Icons.water_drop_outlined,
    ProgressMetric.sleep => Icons.bedtime_outlined,
    ProgressMetric.calories => Icons.local_fire_department_outlined,
    ProgressMetric.mood => Icons.mood,
  };

  @override
  State<MetricFilterButton> createState() => _MetricFilterButtonState();
}

class _MetricFilterButtonState extends State<MetricFilterButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  bool get _isFiltered => widget.selected != ProgressMetric.all;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _toggleMenu() {
    if (_overlay != null) {
      _removeOverlay();
      return;
    }

    final overlay = Overlay.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = widget.selected;

    _overlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeOverlay,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    maxWidth: 260,
                  ),
                  child: GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    color: isDark ? Colors.white : colors.onBackground,
                    opacity: isDark ? 0.14 : 0.08,
                    border: Border.all(
                      color: (isDark ? Colors.white : colors.onBackground)
                          .withValues(alpha: 0.22),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final metric in ProgressMetric.values)
                          _MetricMenuItem(
                            icon: MetricFilterButton.iconFor(metric),
                            label: metric.label,
                            isSelected: metric == selected,
                            colors: colors,
                            textTheme: textTheme,
                            onTap: () {
                              widget.onSelected(metric);
                              _removeOverlay();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlay!);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleMenu,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 22,
                      color: colors.onBackground,
                    ),
                    if (_isFiltered)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.background,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (_isFiltered) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    widget.selected.label,
                    style: textTheme.labelLarge!.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final AppColors colors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _MetricMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? colors.primary : colors.onBackground,
            ),
            const SizedBox(width: AppSpacing.smd),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyLarge!.copyWith(
                  color: isSelected ? colors.primary : colors.onBackground,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 18, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
