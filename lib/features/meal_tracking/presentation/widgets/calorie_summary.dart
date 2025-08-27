// calorie_summary.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/food_provider.dart';

class CalorieSummary extends ConsumerWidget {
  final double totalCalories;
  final Color progressColor;

  const CalorieSummary({
    super.key,
    required this.totalCalories,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final nutrients = ref.watch(dailyNutrientsProvider(userId));
    final nutrientGoals = ref.watch(nutrientGoalsProvider(userId));
    final goalCaloriesAsync = ref.watch(calorieGoalProvider(userId));

    return goalCaloriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error loading goal: $e"),
      data: (goalCalories) {
        return GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          padding: EdgeInsets.all(FixedSizes.box12(context)),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: FixedSizes.box60(context),
                        width: FixedSizes.box60(context),
                        child: CircularProgressIndicator(
                          value: goalCalories > 0
                              ? totalCalories / goalCalories
                              : 0.0,
                          strokeWidth: 6,
                          backgroundColor: AppTheme.colors['white']!
                              .withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation(progressColor),
                        ),
                      ),
                      Icon(
                        Icons.local_dining,
                        size: FixedSizes.box28(context),
                        color: AppTheme.colors['indigo'],
                      ),
                    ],
                  ),
                  SizedBox(width: FixedSizes.box16(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${totalCalories.toStringAsFixed(0)} of ${goalCalories.toStringAsFixed(0)} Cal',
                        style: GoogleFonts.roboto(
                          fontSize: FixedSizes.font18(context),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.colors['onSurface'],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/weekly-calorie-chart'),
                    child: Icon(
                      Icons.bar_chart,
                      color: AppTheme.colors['indigo'],
                      size: FixedSizes.box28(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: FixedSizes.box16(context)),
              Wrap(
                spacing: FixedSizes.box8(context),
                runSpacing: FixedSizes.box8(context),
                children: [
                  _buildNutrientProgress(
                    context,
                    'Protein',
                    nutrients['protein']!,
                    nutrientGoals['protein']!,
                    AppTheme.colors['navBarActive']!,
                  ),
                  _buildNutrientProgress(
                    context,
                    'Fat',
                    nutrients['fat']!,
                    nutrientGoals['fat']!,
                    AppTheme.colors['error']!,
                  ),
                  _buildNutrientProgress(
                    context,
                    'Carbs',
                    nutrients['carbs']!,
                    nutrientGoals['carbs']!,
                    AppTheme.colors['fullProgress']!,
                  ),
                  _buildNutrientProgress(
                    context,
                    'Fiber',
                    nutrients['fiber']!,
                    nutrientGoals['fiber']!,
                    AppTheme.colors['indigo']!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutrientProgress(
    BuildContext context,
    String label,
    double value,
    double goal,
    Color color,
  ) {
    return SizedBox(
      width: FixedSizes.box150(context),
      child: Column(
        children: [
          Text(
            '$label: ${value.toStringAsFixed(1)} / ${goal.toStringAsFixed(0)}g',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['onSurface'],
            ),
          ),
          SizedBox(height: FixedSizes.box4(context)),
          LinearProgressIndicator(
            value: goal > 0 ? value / goal : 0.0,
            backgroundColor: AppTheme.colors['white']!.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }
}
