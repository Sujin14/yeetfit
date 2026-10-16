import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Rounded food photo with an icon fallback for missing or broken images.
class FoodThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const FoodThumbnail({super.key, required this.imageUrl, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final fallback = ColoredBox(
      color: colors.primary.withValues(alpha: 0.15),
      child: Icon(
        Icons.restaurant_rounded,
        color: colors.primary,
        size: size * 0.45,
      ),
    );
    final url = imageUrl;
    final pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.25),
      child: SizedBox.square(
        dimension: size,
        child: url == null || url.isEmpty
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                cacheWidth: pixels,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
