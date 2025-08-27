import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/fixed_sizes.dart';
import '../widgets/weight_app_bar.dart';
import '../widgets/weight_card.dart';
import '../widgets/weight_chart_section.dart';
import '../widgets/weight_goal_section.dart';
import '../widgets/weight_progress_bar.dart';
import '../widgets/weight_tip_card.dart';
import '../widgets/weight_entry_dialog.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';

class WeightTrackingScreen extends ConsumerWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track weight')),
      );
    }

    final currentWeightAsync = ref.watch(currentWeightProvider(userId));
    final goalAsync = ref.watch(weightGoalProvider(userId));

    // Navigate to success page when goal achieved
    ref.listen(currentWeightProvider(userId), (previous, next) {
      next.whenData((currentWeight) {
        goalAsync.whenData((goal) {
          if ((currentWeight - goal.goalWeight).abs() < 0.1) {
            context.push('/weight-success/${goal.goalWeight.toStringAsFixed(1)}');
          }
        });
      });
    });

    return Scaffold(
      appBar: const WeightAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(FixedSizes.spacing(context)),
        child: Column(
          children: [
            SizedBox(
              height: FixedSizes.box200(context),
              child: Lottie.asset(
                'assets/animations/weight.json',
                fit: BoxFit.contain,
              ),
            ),
            const WeightGoalSection(),
            SizedBox(height: FixedSizes.box25(context)),
            Consumer(
              builder: (context, ref, _) {
                final progressData = ref.watch(weightProgressProvider(userId));
                return WeightProgressBar(
                  progress: progressData['progress'],
                  progressColor: progressData['color'],
                );
              },
            ),
            SizedBox(height: FixedSizes.box16(context)),
            Consumer(
              builder: (context, ref, _) {
                final goalAsync = ref.watch(weightGoalProvider(userId));
                return goalAsync.when(
                  data: (goal) => WeightCard(
                    title: 'Goal Weight',
                    weight: goal.goalWeight,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                );
              },
            ),
            SizedBox(height: FixedSizes.box25(context)),
            Consumer(
              builder: (context, ref, _) {
                final goalAsync = ref.watch(weightGoalProvider(userId));
                return goalAsync.when(
                  data: (goal) => WeightCard(
                    title: 'Initial Weight',
                    weight: goal.initialWeight,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                );
              },
            ),
            SizedBox(height: FixedSizes.box25(context)),
            Consumer(
              builder: (context, ref, _) {
                final weightDataAsync = ref.watch(currentWeightProvider(userId));
                return weightDataAsync.when(
                  data: (weight) {
                    final today = DateTime.now().toIso8601String().split('T')[0];
                    return WeightCard(
                      title: 'Current Weight',
                      weight: weight,
                      date: today,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                );
              },
            ),
            SizedBox(height: FixedSizes.box25(context)),
            const WeightTipCard(),
            SizedBox(height: FixedSizes.box16(context)),
            WeightChartSection(userId: userId),
            SizedBox(height: FixedSizes.box60(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => WeightEntryDialog(userId: userId),
          );
        },
        child: Icon(
          Icons.scale,
          size: FixedSizes.icon20(context),
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }
}
