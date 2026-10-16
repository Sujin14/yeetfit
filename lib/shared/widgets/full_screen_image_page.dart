import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Edge-to-edge illustration with a bottom-weighted dark scrim and [content]
/// pinned over its lower edge. Shared by onboarding and the Yana intro.
class FullScreenImagePage extends StatelessWidget {
  final String imagePath;
  final Widget content;

  const FullScreenImagePage({
    super.key,
    required this.imagePath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: content,
          ),
        ),
      ],
    );
  }
}
