import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Drawer header avatar: the Yeetfit profile photo, else the sign-in
/// provider's photo, else the name's first letter.
class DrawerProfileAvatar extends StatelessWidget {
  final String name;
  final String? profileImageUrl;
  final String? authPhotoUrl;

  const DrawerProfileAvatar({
    super.key,
    required this.name,
    this.profileImageUrl,
    this.authPhotoUrl,
  });

  static String? _nonEmpty(String? url) =>
      url != null && url.isNotEmpty ? url : null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final photoUrl = _nonEmpty(profileImageUrl) ?? _nonEmpty(authPhotoUrl);
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: 2),
      ),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: colors.primary,
        foregroundImage: photoUrl != null
            ? CachedNetworkImageProvider(photoUrl)
            : null,
        child: Text(
          initial,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(color: colors.onPrimary),
        ),
      ),
    );
  }
}
