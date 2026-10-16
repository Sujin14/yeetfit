import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'weight_chart_section.dart';
import 'weight_hero_section.dart';
import 'weight_progress_card.dart';
import 'weight_tip_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WeightTrackingBody extends StatelessWidget {
  final String userId;
  final VoidCallback onLogWeight;

  const WeightTrackingBody({
    super.key,
    required this.userId,
    required this.onLogWeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: 'Weight',
          actions: [
            IconButton(
              icon: const Icon(Icons.monitor_weight_outlined),
              tooltip: 'Log weight',
              onPressed: onLogWeight,
            ),
          ],
        ),
        SliverToBoxAdapter(child: WeightHeroSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(child: WeightProgressCard(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: WeightChartSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        const SliverToBoxAdapter(child: WeightTipCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
