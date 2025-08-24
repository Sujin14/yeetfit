import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        vertical: 12.h,
        horizontal: isLargeScreen ? 60.w : size.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 200.h,
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
          SizedBox(height: 16.h),
          Text(
            foodItem.foodName,
            style: GoogleFonts.righteous(
              fontSize: isLargeScreen ? 32.sp : 24.sp,
              color: AppTheme.colors['onSurface'],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            'Nutritional Details (${foodItem.quantity.toStringAsFixed(0)}g)',
            style: GoogleFonts.roboto(
              fontSize: isLargeScreen ? 18.sp : 14.sp,
              color: AppTheme.colors['onSurface']!.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}