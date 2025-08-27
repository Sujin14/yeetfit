// nutrition_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/model/food_model.dart';

class NutritionHeader extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionHeader({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Container(
      width: double.infinity,
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
      padding: EdgeInsets.symmetric(
        vertical: FixedSizes.box12(context),
        horizontal: isLargeScreen ? FixedSizes.box60(context) : size.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: FixedSizes.box200(context),
            child: foodItem.image != null
                ? Image.network(
                    foodItem.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.colors['transparent']!.withOpacity(0.3),
                    ),
                  )
                : Container(
                    color: AppTheme.colors['transparent']!.withOpacity(0.3),
                  ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          Text(
            foodItem.foodName,
            style: GoogleFonts.righteous(
              fontSize: isLargeScreen
                  ? FixedSizes.font32(context)
                  : FixedSizes.font24(context),
              color: AppTheme.colors['onSurface'],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: FixedSizes.box4(context)),
          Text(
            'Nutritional Details (${foodItem.quantity.toStringAsFixed(0)}g)',
            style: GoogleFonts.roboto(
              fontSize: isLargeScreen
                  ? FixedSizes.font18(context)
                  : FixedSizes.font14(context),
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
