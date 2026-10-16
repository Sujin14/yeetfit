import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'step_hero_section.dart';
import 'steps_animation.dart';
import 'steps_chart_card.dart';
import 'steps_tip_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class StepCounterBody extends StatelessWidget {
  final String userId;
  final VoidCallback onEditGoal;

  const StepCounterBody({
    super.key,
    required this.userId,
    required this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: 'Steps',
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Set steps goal',
              onPressed: onEditGoal,
            ),
          ],
        ),
        const SliverToBoxAdapter(child: StepsAnimation()),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: StepHeroSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: StepsChartSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        const SliverToBoxAdapter(child: StepsTipCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
