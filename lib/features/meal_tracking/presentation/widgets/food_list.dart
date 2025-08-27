// food_list.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/food_provider.dart';
import '../widgets/shimmer_card.dart';

class FoodList extends ConsumerWidget {
  final String mealType;

  const FoodList({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final foodItemsAsync = ref.watch(
      dailyFoodItemsProvider('$userId|$mealType'),
    );

    return Expanded(
      child: foodItemsAsync.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                GlassmorphicContainer(
                  color: AppTheme.colors['deepOrange']!,
                  padding: EdgeInsets.all(FixedSizes.box12(context)),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'No $mealType entries',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors['primaryText']!,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: AppTheme.colors['indigo']!,
                      ),
                      onPressed: () => context.push('/food-search', extra: mealType),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: foodItems.length,
            separatorBuilder: (_, __) => SizedBox(height: FixedSizes.box8(context)),
            itemBuilder: (context, index) {
              final item = foodItems[index];

              return GlassmorphicContainer(
                color: AppTheme.colors['deepOrange']!,
                padding: EdgeInsets.all(FixedSizes.box12(context)),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.foodName,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors['primaryText']!,
                    ),
                  ),
                  subtitle: Text(
                    '${item.calories.toStringAsFixed(0)} kcal (${item.quantity.toStringAsFixed(0)}g)',
                    style: GoogleFonts.roboto(
                      color: AppTheme.colors['primaryText']!.withOpacity(0.7),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.info, color: AppTheme.colors['indigo']!),
                    onPressed: () => context.push('/nutrition-details', extra: item),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const ShimmerCard(isListTile: true),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
