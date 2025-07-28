import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../shared/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/food_provider.dart';

class MealSection extends ConsumerWidget {
  final String mealType;

  const MealSection({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

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
                  dailyCaloriesProvider('$userId|$mealType').select((value) => value.value ?? 0.0),
                );
                final goalCaloriesAsync = ref.watch(
                  calorieGoalProvider(userId).select((value) => value),
                );
                return goalCaloriesAsync.when(
                  data: (goalCalories) => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${calories.toStringAsFixed(0)} of ${goalCalories / 5}',
                        style: GoogleFonts.roboto(
                          color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color:  AppTheme.colors['indigo']),
              onPressed: () {
                context.push('/food-search', extra: mealType);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        GlassmorphicContainer(
          color: AppTheme.colors['deepOrange']!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/food-search', extra: mealType);
                },
                child: Text(
                  'Add Your Food for $mealType to Track your Calorie intake🔥😋',
                  style: GoogleFonts.roboto(
                    color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}