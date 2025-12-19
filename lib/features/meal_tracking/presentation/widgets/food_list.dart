import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/routes/tracking_routes_constants.dart';
import '../providers/food_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'shimmer_card.dart';

/// List of food items for a meal.
class FoodList extends ConsumerWidget {
  final String mealType;

  const FoodList({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final foodItemsAsync = ref.watch(dailyFoodItemsProvider('$userId|$mealType'));

    return Expanded(
      child: foodItemsAsync.when(
        data: (foodItems) => ListView.builder(
          itemCount: foodItems.isEmpty ? 1 : foodItems.length,
          itemBuilder: (context, index) {
            if (foodItems.isEmpty) {
              return GlassmorphicContainer(
                color: AppTheme.colors['deepOrange']!,
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () => context.go(TrackingRouteConstants.foodSearch, extra: mealType),
                  child: Text(
                    'Add Your Food for $mealType to Track your Calorie intake🔥😋',
                    style: GoogleFonts.roboto(
                      color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }
            final item = foodItems[index];
            return GlassmorphicContainer(
              color: AppTheme.colors['deepOrange']!,
              padding: const EdgeInsets.all(12),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.foodName,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
                subtitle: Text(
                  '${item.calories.toStringAsFixed(0)} kcal (${item.quantity.toStringAsFixed(0)}g)',
                  style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!.withOpacity(0.7)),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.info, color: AppTheme.colors['indigo']),
                  onPressed: () => context.go(TrackingRouteConstants.nutritionDetails, extra: item),
                ),
              ),
            );
          },
        ),
        loading: () => ShimmerCard(isListTile: true),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}