import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import '../providers/daily_progress_provider.dart';
import 'daily_progress_card.dart';
import 'dashboard_card_error.dart';
import 'dashboard_card_skeleton.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// 2x2 grid of steps, water, sleep and calories for the selected day.
class DailyProgressGrid extends ConsumerWidget {
  final String userId;
  final ValueChanged<String> onOpenTracker;

  const DailyProgressGrid({
    super.key,
    required this.userId,
    required this.onOpenTracker,
  });

  static Widget _grid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: progressAsync.when(
        data: (progress) {
          DailyProgressCard card({
            required String label,
            required num current,
            required num goal,
            required String unit,
            required IconData icon,
            required String route,
          }) {
            return DailyProgressCard(
              label: label,
              currentValue: current.toDouble(),
              goalValue: goal.toDouble(),
              unit: unit,
              icon: icon,
              progressLevel: ProgressLevel.fromRatio(
                goal > 0 ? current / goal : 0,
              ),
              onTap: () => onOpenTracker(route),
            );
          }

          return _grid([
            card(
              label: 'Steps',
              current: progress.steps,
              goal: progress.stepsGoal,
              unit: 'steps',
              icon: Icons.directions_walk,
              route: TrackingRouteConstants.stepCounter,
            ),
            card(
              label: 'Water',
              current: progress.glasses,
              goal: progress.waterGoal,
              unit: 'glasses',
              icon: Icons.water_drop_outlined,
              route: TrackingRouteConstants.waterTracking,
            ),
            card(
              label: 'Sleep',
              current: progress.hoursSlept,
              goal: progress.sleepGoal,
              unit: 'h',
              icon: Icons.bedtime_outlined,
              route: TrackingRouteConstants.sleepTracking,
            ),
            card(
              label: 'Calories',
              current: progress.calories,
              goal: progress.caloriesGoal,
              unit: 'kcal',
              icon: Icons.local_fire_department_outlined,
              route: TrackingRouteConstants.calorieTracking,
            ),
          ]);
        },
        loading: () =>
            _grid(List.generate(4, (_) => const DashboardCardSkeleton())),
        error: (error, _) => DashboardCardError(
          message: 'Could not load progress: $error',
          onRetry: () => ref.invalidate(dailyProgressStreamProvider(userId)),
        ),
      ),
    );
  }
}
