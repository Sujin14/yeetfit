import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'sleep_chart_section.dart';
import 'sleep_hero_section.dart';
import 'sleep_log_button.dart';
import 'sleep_progress_section.dart';
import 'sleep_time_cards.dart';
import 'sleep_tips_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SleepTrackingBody extends StatelessWidget {
  final String userId;
  final VoidCallback onLogSleep;

  const SleepTrackingBody({
    super.key,
    required this.userId,
    required this.onLogSleep,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const GlassSliverAppBar(title: 'Sleep'),
        SliverToBoxAdapter(child: SleepHeroSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(child: SleepTimeCards(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: SleepLogButton(onPressed: onLogSleep)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: SleepProgressSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(child: SleepChartSection(userId: userId)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        const SliverToBoxAdapter(child: SleepTipsCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
