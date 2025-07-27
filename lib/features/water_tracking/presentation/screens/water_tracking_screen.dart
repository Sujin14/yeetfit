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

    return Scaffold(
      appBar: const WaterAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer(
            builder: (context, ref, _) {
              final glassesConsumed = ref.watch(glassesConsumedProvider(userId).select((value) => value.value ?? 0));
              final goalGlasses = ref.watch(waterGoalProvider(userId).select((value) => value.value ?? 8));
              return WaterProgressCard(
                glassesConsumed: glassesConsumed,
                goalGlasses: goalGlasses,
              );
            },
          ),
          const SizedBox(height: 20),
          Consumer(
            builder: (context, ref, _) {
              final glassesConsumed = ref.watch(glassesConsumedProvider(userId).select((value) => value.value ?? 0));
              final goalGlasses = ref.watch(waterGoalProvider(userId).select((value) => value.value ?? 8));
              return WaterCircularIndicator(
                progress: goalGlasses > 0 ? glassesConsumed / goalGlasses : 0.0,
              );
            },
          ),
          const SizedBox(height: 10),
          WaterActionButtons(
            onAdd: () => ref.read(glassesConsumedProvider(userId).notifier).addGlass(),
            onRemove: () => ref.read(glassesConsumedProvider(userId).notifier).removeGlass(),
          ),
          const SizedBox(height: 24),
          const WaterTipCard(),
          const SizedBox(height: 30),
          WaterChartSection(userId: userId),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}