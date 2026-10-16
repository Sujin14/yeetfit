import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Theme-aware shimmer shared by every loading skeleton. Children paint any
/// opaque colour; the shimmer gradient replaces it.
class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // onBackground flips between themes, so the skeleton stays visible on
    // both the dark and light backgrounds.
    return Shimmer.fromColors(
      baseColor: colors.onBackground.withValues(alpha: 0.08),
      highlightColor: colors.onBackground.withValues(alpha: 0.18),
      child: child,
    );
  }
}
