import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Circular coach photo; falls back to the name's initial.
class CoachAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;

  const CoachAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final url = imageUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary.withValues(alpha: 0.25),
      foregroundImage: url == null ? null : CachedNetworkImageProvider(url),
      child: name.isEmpty
          ? Icon(Icons.person, size: radius, color: colors.onBackground)
          : Text(
              name[0].toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: radius * 0.8,
                color: colors.onBackground,
              ),
            ),
    );
  }
}
