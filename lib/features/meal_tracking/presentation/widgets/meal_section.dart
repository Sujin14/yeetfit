import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/food_provider.dart';
import '../widgets/shimmer_card.dart';

class MealSection extends ConsumerWidget {
  final String mealType;

  const MealSection({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];
    final foodItemsAsync = ref.watch(
      dailyFoodItemsProvider('$userId|$mealType'),
    );
    final mealCalorieGoals = ref.watch(mealCalorieGoalsProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              mealType,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            const Spacer(),
            Consumer(
              builder: (context, ref, _) {
                final calories = ref.watch(
                  dailyCaloriesProvider('$userId|$mealType'),
                );
                final mealGoalCalories = mealCalorieGoals[mealType] ?? 350.0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${calories.toStringAsFixed(0)} of ${mealGoalCalories.toStringAsFixed(0)} Cal',
                      style: GoogleFonts.roboto(
                        color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: AppTheme.colors['indigo']),
              onPressed: () => context.push('/food-search', extra: mealType),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        foodItemsAsync.when(
          data: (foodItems) => foodItems.isEmpty
              ? GlassmorphicContainer(
                  color: AppTheme.colors['deepOrange']!,
                  child: GestureDetector(
                    onTap: () => context.push('/food-search', extra: mealType),
                    child: Text(
                      'Add Your Food for $mealType to Track your Calorie intake🔥😋',
                      style: GoogleFonts.roboto(
                        color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: foodItems
                      .map(
                        (item) => ListTile(
                          title: Text(
                            item.foodName,
                            style: GoogleFonts.roboto(
                              color: AppTheme.colors['primaryText'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${item.calories.toStringAsFixed(0)} kcal (${item.quantity.toStringAsFixed(0)}g)',
                            style: GoogleFonts.roboto(
                              color: AppTheme.colors['onSurface']!.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                          onTap: () =>
                              context.push('/nutrition-details', extra: item),
                        ),
                      )
                      .toList(),
                ),
          loading: () => ShimmerCard(isListTile: true),
          error: (error, _) => Text('Error: $error'),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
