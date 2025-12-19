import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../plans/presentation/providers/plan_provider.dart';
import 'no_plan_tile_widget.dart';
import 'plan_tile_widget.dart';
import 'error_tile_widget.dart';
import 'loading_tile_widget.dart';

class PlanListDisplay extends ConsumerWidget {
  const PlanListDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsync = ref.watch(dietPlanProvider);
    final workoutPlanAsync = ref.watch(workoutPlanProvider);

    return ListView(
      children: [
        dietPlanAsync.when(
          data: (plan) {
             if (plan == null) {
              return const NoPlanTileWidget(message: 'No diet plans available.');
            }
            return PlanTileWidget(
            title: 'Diet Plans',
            icon: Icons.restaurant,
            onTap: () {
              context.push('/plans/diet');
            },
          );
          },
          loading: () => const LoadingTileWidget(),
          error: (error, _) => ErrorTileWidget(
            message: error.toString().contains('PERMISSION_DENIED')
                ? 'Permission denied: Please check your authentication'
                : error.toString(),
          ),
        ),
        SizedBox(height: 16.h),
        workoutPlanAsync.when(
          data: (plan) {
            if (plan == null) {
              return const NoPlanTileWidget(message: 'No workout plans available.');
            }
            return PlanTileWidget(
            title: 'Workout Plans',
            icon: Icons.fitness_center,
            onTap: () {
              context.push('/plans/workouts');
            },
          );
          },
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