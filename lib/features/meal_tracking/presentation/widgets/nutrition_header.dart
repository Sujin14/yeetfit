import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../data/model/food_model.dart';

class NutritionHeader extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionHeader({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.colors['teal']!.withOpacity(0.3),
              AppTheme.colors['indigo']!.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          left: isLargeScreen ? 60 : size.width * 0.05,
          right: isLargeScreen ? 60 : size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(color: Colors.black), // back arrow
            const SizedBox(height: 8),
            Center(
              child: foodItem.image != null
                  ? Image.network(
                      foodItem.image!,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: AppTheme.colors['gray']!.withOpacity(0.3),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppTheme.colors['gray']!.withOpacity(0.3),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              foodItem.foodName,
              style: GoogleFonts.righteous(
                fontSize: isLargeScreen ? 32 : size.width * 0.06,
                color: AppTheme.colors['onSurface'],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Nutritional Details (${foodItem.quantity.toStringAsFixed(0)}g)',
              style: GoogleFonts.roboto(
                fontSize: isLargeScreen ? 18 : size.width * 0.035,
                color: AppTheme.colors['onSurface']!.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
