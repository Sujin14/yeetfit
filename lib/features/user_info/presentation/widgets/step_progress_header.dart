import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class StepProgressHeader extends StatelessWidget {
  final int step;
  final int totalSteps;
  final VoidCallback? onBack;

  // Equal side slots keep the step label centred.
  static const double _sideWidth = YeetBackButton.size;

  const StepProgressHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final topInset = MediaQuery.paddingOf(context).top;
    final progress = step / totalSteps;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, math.max(48, topInset + 12), 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _sideWidth,
                child: onBack == null
                    ? null
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: YeetBackButton(onTap: onBack),
                      ),
              ),
              Expanded(
                child: Text(
                  'Step $step of $totalSteps',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: _sideWidth),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: (step - 1) / totalSteps, end: progress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
