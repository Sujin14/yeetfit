import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class SleepTimeCardsShimmer extends StatelessWidget {
  const SleepTimeCardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: FixedSizes.box100(context),
            height: FixedSizes.box18(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(FixedSizes.radius4(context)),
            ),
          ),
        ),
        SizedBox(height: FixedSizes.box30(context)),
        GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: FixedSizes.box56(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
              ),
            ),
          ),
        ),
        SizedBox(height: FixedSizes.box25(context)),
        GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: FixedSizes.box56(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
