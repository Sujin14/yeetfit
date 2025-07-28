import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/theme/theme.dart';
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
  final TextEditingController _controller = TextEditingController();
  List<FoodItem> _searchResults = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchFood(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    try {
      final results = await searchFood(query);
      setState(() => _searchResults = results);
    } catch (e) {
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
          child: TextField(
            controller: _controller,
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
        if (_searchResults.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final food = _searchResults[index];
                return ListTile(
                  title: Text(
                    food.foodName,
                    style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']),
                  ),
                  subtitle: Text(
                    '${food.calories.toStringAsFixed(0)} kcal',
                    style: GoogleFonts.roboto(color: AppTheme.colors['onSurface']!.withOpacity(0.7)),
                  ),
                  onTap: () {
                    ref.read(dailyCaloriesProvider('$userId|${widget.mealType}').notifier).updateCalories(
                          food.foodName,
                          food.calories,
                          food.protein,
                          food.fat,
                          food.carbs,
                          food.fiber,
                        );
                    context.go('/modal/food');
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}