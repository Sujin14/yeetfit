import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../providers/food_provider.dart';

class FoodList extends ConsumerWidget {
  final String mealType;

  const FoodList({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final foodDataAsync = ref.watch(dailyCaloriesProvider('$userId|$mealType'));

    return Expanded(
      child: foodDataAsync.when(
        data: (calories) {
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return GlassmorphicContainer(
                color: AppTheme.colors['deepOrange']!,
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Current $mealType Entry',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors['primaryText']!,
                    ),
                  ),
                  subtitle: Text(
                    'Calories: ${calories.toStringAsFixed(0)} kcal',
                    style: GoogleFonts.roboto(color: AppTheme.colors['primaryText']!.withOpacity(0.7)),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: AppTheme.colors['indigo']!,
                    ),
                    onPressed: () {
                      context.push('/food-search', extra: mealType);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}