import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class SleepChartShimmer extends StatelessWidget {
  const SleepChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.colors['gray']!.withOpacity(0.3),
      highlightColor: AppTheme.colors['gray']!.withOpacity(0.7),
      child: Container(
        height: FixedSizes.box220(context),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.colors['white'],
          borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
        ),
      ),
    );
  }
}
