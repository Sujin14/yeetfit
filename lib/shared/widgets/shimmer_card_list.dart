import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'shimmer_card.dart';
import 'shimmer_wrapper.dart';

/// [count] equal [ShimmerCard]s stacked with [gap] between them, sharing one
/// shimmer sweep.
class ShimmerCardList extends StatelessWidget {
  final int count;
  final double height;
  final double gap;
  final EdgeInsets? margin;

  const ShimmerCardList({
    super.key,
    required this.count,
    required this.height,
    this.gap = AppSpacing.sm,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) SizedBox(height: gap),
            ShimmerCard(height: height, margin: margin),
          ],
        ],
      ),
    );
  }
}
