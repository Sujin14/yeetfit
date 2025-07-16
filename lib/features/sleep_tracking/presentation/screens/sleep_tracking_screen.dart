import 'package:flutter/material.dart';

import '../widgets/sleep_app_bar.dart';
import '../widgets/sleep_chart_section.dart';
import '../widgets/sleep_progress_section.dart';
import '../widgets/sleep_time_card.dart';
import '../widgets/sleep_tips_card.dart';


class SleepTrackingScreen extends StatelessWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: const SleepAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12 : 16,
              vertical: isDesktop ? 12 : 20,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SleepProgressSection(),
                SizedBox(height: 16),
                SleepTimeCards(),
                SizedBox(height: 20),
                SleepTipsCard(),
                SizedBox(height: 20),
                SleepChartSection(),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5).withOpacity(0.3),
        onPressed: () {},
        child: const Icon(
          Icons.bed,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}