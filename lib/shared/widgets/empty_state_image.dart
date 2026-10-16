import 'package:flutter/material.dart';

/// Decorative illustration above an empty-state message.
class EmptyStateImage extends StatelessWidget {
  final String assetPath;
  final double height;

  const EmptyStateImage({
    super.key,
    required this.assetPath,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: height,
      fit: BoxFit.contain,
      cacheHeight: (height * MediaQuery.devicePixelRatioOf(context)).round(),
      excludeFromSemantics: true,
    );
  }
}
