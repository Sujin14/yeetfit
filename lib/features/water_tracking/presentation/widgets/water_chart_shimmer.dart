import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class WaterChartShimmer extends StatelessWidget {
  const WaterChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
      highlightColor: AppTheme.colors['gray']!.withOpacity(0.1),
      child: SizedBox(
        height: FixedSizes.box200(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final heights = [
              FixedSizes.box120(context),
              FixedSizes.box150(context),
              FixedSizes.box80(context),
              FixedSizes.box100(context),
              FixedSizes.box150(context),
              FixedSizes.box120(context),
              FixedSizes.box80(context)
            ];
            return Container(
              width: FixedSizes.box18(context),
              height: heights[index],
              decoration: BoxDecoration(
                color: AppTheme.colors['white'],
                borderRadius: BorderRadius.circular(FixedSizes.radius8(context)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
