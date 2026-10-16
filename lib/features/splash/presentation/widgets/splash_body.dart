import 'package:flutter/material.dart';
import 'splash_background_image.dart';
import 'splash_logo.dart';
import 'splash_wordmark.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Background fade, elastic logo pop and sliding wordmark, driven by the
/// animations owned by `SplashScreen`.
class SplashBody extends StatelessWidget {
  final Animation<double> backgroundOpacity;
  final Animation<double> logoScale;
  final Animation<double> textOpacity;
  final Animation<Offset> textSlide;

  const SplashBody({
    super.key,
    required this.backgroundOpacity,
    required this.logoScale,
    required this.textOpacity,
    required this.textSlide,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: backgroundOpacity,
          child: const SplashBackgroundImage(),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(scale: logoScale, child: const SplashLogo()),
              const SizedBox(height: AppSpacing.lg),
              SlideTransition(
                position: textSlide,
                child: FadeTransition(
                  opacity: textOpacity,
                  child: const SplashWordmark(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
