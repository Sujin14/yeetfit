import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/mood_fitness_correlation.dart';
import '../providers/mood_correlation_provider.dart';
import 'mood_correlation_card.dart';
import 'mood_correlation_locked_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Progress-tab section comparing mood with fitness completion; locked until
/// 14 days have both.
class MoodCorrelationChart extends ConsumerWidget {
  final String userId;

  const MoodCorrelationChart({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correlationAsync = ref.watch(moodFitnessCorrelationProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: correlationAsync.when(
        loading: () => const ShimmerCard(
          height: MoodCorrelationCard.height,
          margin: EdgeInsets.zero,
        ),
        error: (error, _) => GlassCard(
          borderRadius: 20,
          padding: EdgeInsets.zero,
          child: YeetErrorState.compact(
            message: 'Could not load mood insights: $error',
            onRetry: () =>
                ref.invalidate(moodFitnessCorrelationProvider(userId)),
          ),
        ),
        data: (correlation) => correlation.isUnlocked
            ? MoodCorrelationCard(correlation: correlation)
            : MoodCorrelationLockedCard(
                loggedDays: correlation.pairedDays,
                requiredDays: MoodFitnessCorrelation.requiredPairedDays,
              ),
      ),
    );
  }
}
