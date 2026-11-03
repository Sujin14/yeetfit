import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Circular coach photo for chat UI. Valid http(s) URLs load with
/// [CachedNetworkImage]; loading and error keep the initial so size never jumps.
class ChatParticipantAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final double radius;

  const ChatParticipantAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
    this.radius = 20,
  });

  static bool _isHttpUrl(String? url) {
    if (url == null) return false;
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Widget _initial(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final label = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return ColoredBox(
      color: colors.primary.withValues(alpha: 0.25),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: colors.onBackground,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final url = photoUrl?.trim();
    final showPhoto = _isHttpUrl(url);

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: showPhoto
            ? CachedNetworkImage(
                imageUrl: url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, _) => _initial(context),
                errorWidget: (context, _, _) => _initial(context),
              )
            : _initial(context),
      ),
    );
  }
}
