import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_border_painter.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Full-width in-scroll replacement for the old floating action button.
class SleepLogButton extends StatelessWidget {
  static const double _height = 52;
  static const double _radius = 26;

  final VoidCallback onPressed;

  const SleepLogButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: CustomPaint(
        foregroundPainter: GradientBorderPainter(
          gradient: LinearGradient(colors: [colors.primary, colors.secondary]),
          borderRadius: _radius,
        ),
        child: SizedBox(
          height: _height,
          child: GlassCard(
            borderRadius: _radius,
            padding: EdgeInsets.zero,
            border: const Border(),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(_radius),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Log Sleep',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
