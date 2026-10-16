import 'package:flutter/material.dart';

/// Full-bleed splash artwork.
class SplashBackgroundImage extends StatelessWidget {
  const SplashBackgroundImage({super.key});

  /// Shared with `precacheImage` so the decoded frame is reused.
  static const ImageProvider image = AssetImage('assets/images/splash_bg.webp');

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
