import 'package:flutter/material.dart';

/// 96×96 rounded Yeetfit logo.
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  static const double size = 96;

  /// Decoded at 3x the display size instead of the 1254px source; shared with
  /// `precacheImage` so the decoded frame is reused.
  static const ImageProvider image = ResizeImage(
    AssetImage('assets/images/yeetfit_logo.webp'),
    width: 288,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const Image(image: image, width: size, height: size),
    );
  }
}
