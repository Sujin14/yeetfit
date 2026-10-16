import 'package:flutter/material.dart';

/// Full-bleed waving Yana behind the empty chat, darkened towards the bottom
/// so the greeting, chips and input stay legible.
class YanaChatBackground extends StatelessWidget {
  const YanaChatBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/yana_wave.webp', fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.3, 0.7, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.92),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
