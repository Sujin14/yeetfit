import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/explore_providers.dart';
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
          data: (plan) => plan == null
              ? const ErrorTileWidget(message: 'No diet plan available')
              : PlanTileWidget(
                  title: 'Diet Plan',
                  icon: Icons.restaurant,
                  onTap: () {
                    debugPrint(
                      'Diet Plan tapped: id=${plan.id}, type=${plan.type}',
                    );
                    context.push(
                      '/plans/${plan.id}',
                      extra: {'plan': plan, 'category': 'diet'},
                    );
                  },
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
          data: (plan) => plan == null
              ? const ErrorTileWidget(message: 'No workout plan available')
              : PlanTileWidget(
                  title: 'Workout Plan',
                  icon: Icons.fitness_center,
                  onTap: () {
                    debugPrint(
                      'Workout Plan tapped: id=${plan.id}, type=${plan.type}',
                    );
                    context.push(
                      '/plans/${plan.id}',
                      extra: {'plan': plan, 'category': 'workouts'},
                    );
                  },
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
