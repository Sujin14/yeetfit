import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import '../../data/models/plan_model.dart';
import '../utils/plan_display.dart';
import 'diet_meal_card.dart';
import 'exercise_card.dart';
import 'plan_detail_app_bar.dart';
import 'plan_info_section.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanDetailView extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onToggleFavorite;
  final VoidCallback onStartPlan;

  const PlanDetailView({
    super.key,
    required this.plan,
    required this.onToggleFavorite,
    required this.onStartPlan,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final exercises = plan.exercises;
    final mealNames = plan.orderedMealNames;
    final meals = plan.meals;
    final isEmpty = plan.isDiet ? mealNames.isEmpty : exercises.isEmpty;

    return CustomScrollView(
      slivers: [
        PlanDetailAppBar(
          title: plan.title,
          imageUrl: plan.imageUrl,
          isFavorite: plan.isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
        SliverToBoxAdapter(child: PlanInfoSection(plan: plan)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              0,
              AppSpacing.screenEdge,
              AppSpacing.sm,
            ),
            child: Text(
              plan.isDiet ? 'Meals' : 'Exercises',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onBackground),
            ),
          ),
        ),
        if (isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              child: Text(
                plan.isDiet ? 'No meals available' : 'No exercises available',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
              ),
            ),
          )
        else if (plan.isDiet)
          SliverList.builder(
            itemCount: mealNames.length,
            itemBuilder: (context, index) {
              final name = mealNames[index];
              return DietMealCard(
                name: name,
                meal: Map<String, dynamic>.from(meals[name] as Map? ?? {}),
              );
            },
          )
        else
          SliverList.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) =>
                ExerciseCard(index: index, exercise: exercises[index]),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: GradientButton(label: 'Start Plan', onPressed: onStartPlan),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
