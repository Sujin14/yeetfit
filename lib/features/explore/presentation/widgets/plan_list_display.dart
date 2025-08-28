import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../plans/presentation/providers/plan_provider.dart';
import '../providers/explore_plan_provider.dart';
import 'error_tile_widget.dart';
import 'loading_tile_widget.dart';
import 'plan_tile_widget.dart';

class PlanListDisplay extends ConsumerWidget {
  const PlanListDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsync = ref.watch(dietPlanProvider);
    final workoutPlanAsync = ref.watch(workoutPlanProvider);
    final controller = ref.read(planProvider.notifier);

    return ListView(
      children: [
        dietPlanAsync.when(
          data: (plan) => PlanTileWidget(
            title: 'Diet Plans',
            icon: Icons.restaurant,
            onTap: () => controller.navigateToDietPlan(context),
          ),
          loading: () => const LoadingTileWidget(),
          error: (error, _) => ErrorTileWidget(
            message: error.toString().contains('PERMISSION_DENIED')
                ? 'Permission denied: Please check your authentication'
                : error.toString(),
          ),
        ),
        SizedBox(height: 16.h),
        workoutPlanAsync.when(
          data: (plan) => PlanTileWidget(
            title: 'Workout Plans',
            icon: Icons.fitness_center,
            onTap: () => controller.navigateToWorkoutPlan(context),
          ),
          loading: () => const LoadingTileWidget(),
          error: (error, _) => ErrorTileWidget(
            message: error.toString().contains('PERMISSION_DENIED')
                ? 'Permission denied: Please check your authentication'
                : error.toString(),
          ),
        ),
      ],
    );
  }
}