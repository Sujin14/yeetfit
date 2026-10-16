import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_controller.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_steps.dart';
import 'package:yeetfit/core/walkthrough/walkthrough_trigger.dart';
import 'package:yeetfit/core/walkthrough/yana_showcase.dart';
import 'package:yeetfit/features/mood/presentation/widgets/mood_correlation_chart.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/progress_metric.dart';
import '../providers/progress_provider.dart';
import '../widgets/calorie_goal_banner.dart';
import '../widgets/metric_filter_row.dart';
import '../widgets/progress_calendar_grid.dart';
import '../widgets/progress_header.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    final metric = ref.watch(selectedProgressMetricProvider);
    final query = (month: month, metric: metric);
    final progressAsync = ref.watch(monthlyProgressProvider(query));
    final userId = ref.watch(authUserIdProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: ProgressHeader(month: month)),
          SliverToBoxAdapter(
            child: YanaShowcase(
              step: ProgressTour.filter,
              child: MetricFilterRow(
                selected: metric,
                onSelected: (value) => ref
                    .read(selectedProgressMetricProvider.notifier)
                    .select(value),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.smd)),
          if (userId != null && metric == ProgressMetric.calories)
            SliverToBoxAdapter(child: CalorieGoalBanner(userId: userId)),
          SliverToBoxAdapter(
            child: progressAsync.when(
              skipLoadingOnRefresh: false,
              // The tour starts once the calendar (its last target) exists.
              data: (days) {
                final calendar = YanaShowcase(
                  step: ProgressTour.calendar,
                  child: ProgressCalendarGrid(month: month, days: days),
                );
                if (userId == null) return calendar;
                return WalkthroughTrigger(
                  tourKey: WalkthroughController.progress,
                  userId: userId,
                  targets: ProgressTour.targets,
                  introMessage: ProgressTour.introMessage,
                  child: calendar,
                );
              },
              loading: () => const ShimmerCard(height: 280),
              error: (error, _) => YeetErrorState(
                message: 'Could not load progress: $error',
                onRetry: () =>
                    ref.invalidate(monthlyProgressDataProvider(query)),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          if (userId != null)
            SliverToBoxAdapter(child: MoodCorrelationChart(userId: userId)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
