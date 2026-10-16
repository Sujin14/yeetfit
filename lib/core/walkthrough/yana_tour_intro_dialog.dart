import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Yana's "Shall we go?" prompt before a tour. Pops `true` for "Let's go!"
/// and `false` for "Maybe later".
class YanaTourIntroDialog extends StatelessWidget {
  final String title;
  final String message;

  const YanaTourIntroDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static const double _imageHeight = 120;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      content: GlassCard(
        borderRadius: 24,
        opacity: 0.25,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/yana_avatar.webp',
              height: _imageHeight,
              cacheHeight: (_imageHeight * pixelRatio).round(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge!.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Maybe later'),
                  ),
                ),
                const SizedBox(width: AppSpacing.smd),
                Expanded(
                  child: GradientButton(
                    label: "Let's go! 🚀",
                    height: 48,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
