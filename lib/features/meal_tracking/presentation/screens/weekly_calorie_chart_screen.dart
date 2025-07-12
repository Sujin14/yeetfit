import 'package:flutter/material.dart';

import '../widgets/calorie_chart_card.dart';

class WeeklyCalorieChartScreen extends StatelessWidget {
  const WeeklyCalorieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Weekly Calorie Intake',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CalorieChartCard(),
      ),
    );
  }
}