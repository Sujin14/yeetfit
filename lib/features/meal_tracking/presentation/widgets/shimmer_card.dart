// shimmer_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class ShimmerCard extends StatelessWidget {
  final bool isListTile;
  final bool isChart;
  final bool isSummary;
  final double height;

  const ShimmerCard({
    super.key,
    this.isListTile = false,
    this.isChart = false,
    this.isSummary = false,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = AppTheme.colors['gray']!.withOpacity(0.3);
    final highlightColor = AppTheme.colors['white']!.withOpacity(0.1);

    if (isChart) {
      return SizedBox(
        height: FixedSizes.box350(context),
        child: GlassmorphicContainer(
          color: AppTheme.colors['indigo']!,
          padding: EdgeInsets.all(FixedSizes.box24(context)),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: FixedSizes.box20(context),
                  width: double.infinity,
                  color: baseColor,
                ),
                SizedBox(height: FixedSizes.box24(context)),
                Container(
                  height: FixedSizes.box220(context),
                  color: baseColor,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isSummary) {
      return GlassmorphicContainer(
        color: AppTheme.colors['deepOrange']!,
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: FixedSizes.box60(context),
                    width: FixedSizes.box60(context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(width: FixedSizes.box16(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: FixedSizes.box18(context),
                        width: FixedSizes.box120(context),
                        color: baseColor,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: FixedSizes.box28(context),
                    width: FixedSizes.box28(context),
                    color: baseColor,
                  ),
                ],
              ),
              SizedBox(height: FixedSizes.box16(context)),
              Wrap(
                spacing: FixedSizes.box8(context),
                runSpacing: FixedSizes.box8(context),
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: FixedSizes.box150(context),
                    child: Column(
                      children: [
                        Container(
                          height: FixedSizes.box14(context),
                          width: FixedSizes.box100(context),
                          color: baseColor,
                        ),
                        SizedBox(height: FixedSizes.box4(context)),
                        Container(
                          height: FixedSizes.box4(context),
                          width: double.infinity,
                          color: baseColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      padding: EdgeInsets.all(FixedSizes.box12(context)),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: isListTile
            ? ListTile(
                contentPadding: EdgeInsets.zero,
                title: Container(
                  height: FixedSizes.box16(context),
                  width: FixedSizes.box100(context),
                  color: baseColor,
                ),
                subtitle: Container(
                  height: FixedSizes.box14(context),
                  width: FixedSizes.box80(context),
                  color: baseColor,
                ),
                trailing: Container(
                  height: FixedSizes.box24(context),
                  width: FixedSizes.box24(context),
                  color: baseColor,
                ),
              )
            : Container(
                height: FixedSizes.custom(height, height + 20, height + 40, context),
                color: baseColor,
              ),
      ),
    );
  }
}
