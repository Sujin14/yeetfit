import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'shimmer_wrapper.dart';

/// Rounded skeleton block. Shimmers on its own, or joins the sweep of an
/// enclosing [ShimmerWrapper] so grouped skeletons animate as one.
/// A null [width] or [height] fills the parent in that direction.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.onBackground,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    // Nested shimmers would each run their own animation and shader mask.
    final insideShimmer =
        context.findAncestorWidgetOfExactType<Shimmer>() != null;
    return insideShimmer ? box : ShimmerWrapper(child: box);
  }
}
