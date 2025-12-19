import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import 'steps_progress_card.dart';

// Container for steps progress card.
class StepsProgressCardContainer extends ConsumerWidget {
  final String userId;
  final String today;

  const StepsProgressCardContainer({
    super.key,
    required this.userId,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsCountProvider(userId));
    final goalSteps = ref.watch(
      stepsGoalProvider(userId).select((value) => value.value ?? 10000),
    );
    final progressColor = ref.watch(
      dailyStepsProgressColorProvider('$userId|$today'),
    );

    return stepsAsync.when(
      data: (steps) => StepsProgressCard(
        steps: steps,
        goalSteps: goalSteps,
        progressColor: progressColor,
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
