import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/food_search_bar.dart';
import '../widgets/food_list.dart';

class FoodSearchScreenBody extends StatelessWidget {
  final String mealType;

  const FoodSearchScreenBody({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          FoodSearchBar(mealType: mealType),
          SizedBox(height: 12.h),
          FoodList(mealType: mealType),
        ],
      ),
    );
  }
}