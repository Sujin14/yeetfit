import 'package:flutter/material.dart';

import '../widgets/water_action_button.dart';
import '../widgets/water_app_bar.dart';
import '../widgets/water_chart_section.dart';
import '../widgets/water_circular_indicator.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_tip_card.dart';


class WaterTrackingScreen extends StatelessWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaterAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          WaterProgressCard(),
          SizedBox(height: 20),
          WaterCircularIndicator(),
          SizedBox(height: 10),
          WaterActionButtons(),
          SizedBox(height: 24),
          WaterTipCard(),
          SizedBox(height: 30),
          WaterChartSection(),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}