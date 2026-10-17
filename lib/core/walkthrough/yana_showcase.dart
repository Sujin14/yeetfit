import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'walkthrough_controller.dart';
import 'yana_tooltip.dart';
import 'yana_tour_step.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Spotlights [child] with Yana's tooltip when [step] is the active target.
class YanaShowcase extends StatelessWidget {
  final YanaTourStep step;
  final Widget child;

  const YanaShowcase({super.key, required this.step, required this.child});

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: step.key,
      overlayColor: Colors.black,
      overlayOpacity: 0.75,
      targetPadding: const EdgeInsets.all(AppSpacing.sm),
      targetBorderRadius: BorderRadius.circular(16),
      targetShapeBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      // Only the tooltip buttons advance, so a stray tap can't skip a step.
      disableBarrierInteraction: true,
      container: YanaTooltip(
        message: step.message,
        isLast: step.isLast,
        currentStep: step.number,
        totalSteps: step.total,
        onNext: () => ShowCaseWidget.of(context).next(),
        onSkip: () => WalkthroughController.skip(context),
      ),
      child: child,
    );
  }
}
