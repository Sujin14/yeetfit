import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/calorie_chart_card.dart';

class WeeklyCalorieChartScreenBody extends StatelessWidget {
  final String userId;

  const WeeklyCalorieChartScreenBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CalorieChartCard(userId: userId),
    );
  }
}