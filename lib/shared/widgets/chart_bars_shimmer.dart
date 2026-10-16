import 'package:flutter/material.dart';
import 'shimmer_box.dart';
import 'shimmer_wrapper.dart';

/// Seven shimmering bars for a weekly chart; fills the parent's height.
class ChartBarsShimmer extends StatelessWidget {
  static const _barFractions = [0.55, 0.75, 0.4, 0.6, 0.85, 0.5, 0.65];

  const ChartBarsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : 200.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final fraction in _barFractions)
                ShimmerBox(
                  width: 18,
                  height: maxHeight * fraction,
                  borderRadius: 6,
                ),
            ],
          );
        },
      ),
    );
  }
}
