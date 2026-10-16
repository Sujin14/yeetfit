import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// 48px avatar with a primary ring; falls back to initials when there is no
/// photo.
class DashboardAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final VoidCallback? onTap;

  const DashboardAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.onTap,
  });

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primary,
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: colors.primary,
          backgroundImage: hasPhoto
              ? CachedNetworkImageProvider(photoUrl!)
              : null,
          child: hasPhoto
              ? null
              : Text(
                  _initials(name),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: colors.onPrimary),
                ),
        ),
      ),
    );
  }
}
