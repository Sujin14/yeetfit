import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/food_model.dart';
import '../widgets/nutrition_header.dart';
import 'nutrition_card.dart';

class NutritionDetailsScreenBody extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionDetailsScreenBody({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80.w : 16.w,
          vertical: 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NutritionHeader(foodItem: foodItem),
            SizedBox(height: 24.h),
            NutritionCards(foodItem: foodItem),
          ],
        ),
      ),
    );
  }
}