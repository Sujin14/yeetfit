import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../providers/weight_provider.dart';
import 'weight_card.dart';

/// List of weight cards for goal, initial, and current.
class WeightCardsList extends ConsumerWidget {
  final String userId;

  const WeightCardsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(weightGoalProvider(userId));
    final currentWeightAsync = ref.watch(currentWeightProvider(userId));

    return Column(
      children: [
        // Goal card
        goalAsync.when(
          data: (goal) => WeightCard(
            title: 'Goal Weight',
            weight: goal.goalWeight,
          ),
          loading: () => ShimmerLoading(height: 60.h, width: double.infinity,), // Polish loading
          error: (error, _) => const Text('Error loading goal'), // Polish error
        ),
        SizedBox(height: 25.h),
        // Initial weight card
        goalAsync.when(
          data: (goal) => WeightCard(
            title: 'Initial Weight',
            weight: goal.initialWeight,
          ),
          loading: () => ShimmerLoading(height: 60.h, width: double.infinity,),
          error: (error, _) => const Text('Error loading initial weight'),
        ),
        SizedBox(height: 25.h),
        // Current weight card
        currentWeightAsync.when(
          data: (weight) {
            final today = DateTime.now().toIso8601String().split('T')[0];
            return WeightCard(
              title: 'Current Weight',
              weight: weight,
              date: today,
            );
          },
          loading: () => ShimmerLoading(height: 60.h, width: double.infinity,),
          error: (error, _) => const Text('Error loading current weight'),
        ),
      ],
    );
  }
}