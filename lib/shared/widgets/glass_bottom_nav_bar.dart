import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yeetfit/features/track_options/presentation/screens/track_option_modal.dart';
import 'package:yeetfit/shared/widgets/glass_nav_item.dart';
import 'package:yeetfit/shared/widgets/glass_track_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Floating Liquid Glass navigation pill used by the app shell.
///
/// Indices follow [NavigationTab]. Index 2 is the center "Track" action: it
/// opens [TrackOptionsModal] instead of reporting an index change.
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  /// Wraps the center Track button, e.g. to spotlight it in a tour.
  final Widget Function(Widget button)? trackButtonWrapper;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.trackButtonWrapper,
  });

  /// Bottom space shell pages must reserve so content is not hidden by the bar.
  static const double contentClearance = 88;

  static const double _barHeight = 64;
  static const double _centerOverhang = 10;
  static const double _centerDiameter = 60;

  void _showTrackOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => const TrackOptionsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(32);
    final trackButton = GlassTrackButton(
      diameter: _centerDiameter,
      onTap: () => _showTrackOptions(context),
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),
        // The extra height lets the center button overhang the pill while
        // staying inside this widget's bounds, so its top edge is tappable.
        child: SizedBox(
          height: _barHeight + _centerOverhang,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                top: _centerOverhang,
                // The shadow sits outside the clip so it isn't cut off.
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            GlassNavItem(
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home,
                              label: 'Home',
                              isActive: currentIndex == 0,
                              onTap: () => onIndexChanged(0),
                            ),
                            GlassNavItem(
                              icon: Icons.explore_outlined,
                              activeIcon: Icons.explore,
                              label: 'Explore',
                              isActive: currentIndex == 1,
                              onTap: () => onIndexChanged(1),
                            ),
                            const Spacer(),
                            GlassNavItem(
                              icon: Icons.bar_chart_outlined,
                              activeIcon: Icons.bar_chart,
                              label: 'Progress',
                              isActive: currentIndex == 3,
                              onTap: () => onIndexChanged(3),
                            ),
                            GlassNavItem(
                              icon: Icons.groups_outlined,
                              activeIcon: Icons.groups,
                              label: 'Coaches',
                              isActive: currentIndex == 4,
                              onTap: () => onIndexChanged(4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              trackButtonWrapper?.call(trackButton) ?? trackButton,
            ],
          ),
        ),
      ),
    );
  }
}
