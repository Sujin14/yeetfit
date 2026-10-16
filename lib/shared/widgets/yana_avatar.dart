import 'package:flutter/material.dart';

/// Rounded crop of Yana's portrait, used wherever the AI coach is shown.
class YanaAvatar extends StatelessWidget {
  final double size;

  const YanaAvatar({super.key, this.size = 44});

  static const String _assetPath = 'assets/images/yana_avatar.webp';

  // The source is a full-body portrait; zoom towards the face so it reads at
  // avatar sizes.
  static const double _faceZoom = 1.7;
  static const Alignment _faceAnchor = Alignment(0, -0.35);

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: Transform.scale(
          scale: _faceZoom,
          alignment: _faceAnchor,
          child: Image.asset(
            _assetPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            cacheWidth: (size * _faceZoom * pixelRatio).round(),
          ),
        ),
      ),
    );
  }
}
