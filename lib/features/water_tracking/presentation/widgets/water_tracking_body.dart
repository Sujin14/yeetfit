import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'water_action_row.dart';
import 'water_chart_section.dart';
import 'water_circular_card.dart';
import 'water_hero_section.dart';
import 'water_tip_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WaterTrackingBody extends StatelessWidget {
  final String userId;
  final int consumed;
  final int goal;
  final VoidCallback onAddGlass;
  final VoidCallback onRemoveGlass;
  final VoidCallback onEditGoal;

  const WaterTrackingBody({
    super.key,
    required this.userId,
    required this.consumed,
    required this.goal,
    required this.onAddGlass,
    required this.onRemoveGlass,
    required this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: 'Hydration',
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit goal',
              onPressed: onEditGoal,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: WaterHeroSection(consumed: consumed, goal: goal),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: WaterCircularCard(consumed: consumed, goal: goal),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: WaterActionRow(onAdd: onAddGlass, onRemove: onRemoveGlass),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(child: WaterChartSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        const SliverToBoxAdapter(child: WaterTipCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
