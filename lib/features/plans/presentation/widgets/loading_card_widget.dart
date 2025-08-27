import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: FixedSizes.box200(context),
      borderRadius: FixedSizes.borderRadius(context),
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!,
          AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppTheme.colors['navigationAccent']!.withOpacity(0.4),
        highlightColor: AppTheme.colors['navigationAccent']!.withOpacity(0.8),
        period: const Duration(seconds: 1),
        child: Container(
          width: double.infinity,
          height: FixedSizes.box200(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              FixedSizes.borderRadius(context),
            ),
            color: AppTheme.colors['navigationAccent']!.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
