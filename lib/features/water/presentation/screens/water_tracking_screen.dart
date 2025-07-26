import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/water_action_button.dart';
import '../widgets/water_app_bar.dart';
import '../widgets/water_chart_section.dart';
import '../widgets/water_circular_indicator.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_tip_card.dart';
import '../providers/water_provider.dart';

class WaterTrackingScreen extends ConsumerWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track water intake')),
      );
    }

    final waterDataAsync = ref.watch(waterDataProvider(userId));
    final waterGoalAsync = ref.watch(waterGoalProvider(userId));

    return Scaffold(
      appBar: const WaterAppBar(),
      body: waterDataAsync.when(
        data: (waterData) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WaterProgressCard(
              glassesConsumed: waterData?.glassesConsumed ?? 0,
              goalGlasses: waterGoalAsync.value ?? 8,
            ),
            const SizedBox(height: 20),
            WaterCircularIndicator(
              progress: waterData != null && waterGoalAsync.value != null
                  ? waterData.glassesConsumed / waterGoalAsync.value!
                  : 0.0,
            ),
            const SizedBox(height: 10),
            WaterActionButtons(
              onAdd: () => ref.read(waterDataProvider(userId).notifier).addGlass(),
              onRemove: () => ref.read(waterDataProvider(userId).notifier).removeGlass(),
            ),
            const SizedBox(height: 24),
            const WaterTipCard(),
            const SizedBox(height: 30),
            WaterChartSection(userId: userId),
            const SizedBox(height: 50),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}