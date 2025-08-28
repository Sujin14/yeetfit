import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../data/model/food_model.dart';
import '../../domain/services/food_search_api.dart';
import '../providers/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodSearchBar extends ConsumerStatefulWidget {
  final String mealType;

  const FoodSearchBar({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchBar> createState() => _FoodSearchBarState();
}

class _FoodSearchBarState extends ConsumerState<FoodSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '100');
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _searchFood(String query) async {
    try {
      final results = await searchFood(query);
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching food: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Column(
      children: [
        GlassmorphicContainer(
          color: AppTheme.colors['indigo']!,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchFood,
                  decoration: InputDecoration(
                    labelText: 'Enter food name',
                    labelStyle: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.fastfood, color: AppTheme.colors['onSurface']),
                    suffixIcon: Icon(Icons.search, color: AppTheme.colors['onSurface']),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 100.w,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Qty (g)',
                    labelStyle: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']),
                ),
              ),
            ],
          ),
        ),
        if (_searchResults.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final food = _searchResults[index]['food'];
                final quantity = double.tryParse(_quantityController.text) ?? 100.0;
                try {
                  final foodItem = FoodItem.fromJson(food, quantity: quantity);
                  return ListTile(
                    title: Text(
                      food['label'] ?? 'Unknown Food',
                      style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']),
                    ),
                    subtitle: Text(
                      '${foodItem.calories.toStringAsFixed(0)} kcal (${quantity.toStringAsFixed(0)}g)',
                      style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!.withOpacity(0.7)),
                    ),
                    onTap: () {
                      ref
                          .read(dailyFoodItemsProvider('$userId|${widget.mealType}').notifier)
                          .addFoodItem(
                            foodItem.foodName,
                            foodItem.calories,
                            foodItem.protein,
                            foodItem.fat,
                            foodItem.carbs,
                            foodItem.fiber,
                            quantity,
                            foodItem.image,
                          );
                      context.go('/modal/food');
                    },
                  );
                } catch (e) {
                  return ListTile(
                    title: Text(
                      food['label'] ?? 'Unknown Food',
                      style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']),
                    ),
                    subtitle: Text(
                      'Error loading nutrition data',
                      style: GoogleFonts.roboto(color: AppTheme.colors['error']),
                    ),
                  );
                }
              },
            ),
          ),
        if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Text(
              'No results found',
              style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!.withOpacity(0.7)),
            ),
          ),
      ],
    );
  }
}