import 'package:flutter/material.dart';

import '../widgets/steps_app_bar.dart';
import '../widgets/steps_calories_card.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_progress_card.dart';
import '../widgets/steps_tip_card.dart';


class StepCounterScreen extends StatelessWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: const StepsAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        StepsProgressCard(),
                        SizedBox(height: 20),
                        StepsCaloriesCard(),
                        SizedBox(height: 20),
                        StepsTipCard(),
                      ],
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20 : 10),
                  const Expanded(child: StepsChartCard()),
                ],
              )
            : const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepsProgressCard(),
                  SizedBox(height: 18),
                  StepsCaloriesCard(),
                  SizedBox(height: 18),
                  StepsTipCard(),
                  SizedBox(height: 18),
                  StepsChartCard(),
                  SizedBox(height: 60),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5).withOpacity(0.3),
        onPressed: () {},
        child: const Icon(
          Icons.directions_walk_rounded,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
