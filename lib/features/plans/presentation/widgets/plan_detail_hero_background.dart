import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Expanded app bar background: plan image under a dark scrim, or a brand
/// gradient when the plan has no image.
class PlanDetailHeroBackground extends StatelessWidget {
  final String? imageUrl;

  const PlanDetailHeroBackground({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final gradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.primary],
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl == null)
          gradient
        else
          CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (_, _) => gradient,
            errorWidget: (_, _, _) => gradient,
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: imageUrl == null ? 0.05 : 0.25),
                Colors.black.withValues(alpha: imageUrl == null ? 0.25 : 0.65),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
