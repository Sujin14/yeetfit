import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../providers/sleep_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SleepHeroSection extends ConsumerWidget {
  final String userId;

  const SleepHeroSection({super.key, required this.userId});

  static String formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  static String messageFor(ProgressLevel level) => switch (level) {
    ProgressLevel.full => 'Well rested! 🌙',
    ProgressLevel.threeQuarter => 'Nearly a full night',
    ProgressLevel.half => 'A bit short on sleep',
    ProgressLevel.quarter => 'Try to get to bed earlier tonight',
    ProgressLevel.none => 'Log last night\'s sleep',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final sleep = ref.watch(todaySleepProvider(userId)).value;
    final duration = sleep?.duration ?? 0.0;
    final goalHours = sleep?.goalHours ?? 8.0;
    final level = ProgressLevel.fromRatio(
      goalHours > 0 ? duration / goalHours : 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Lottie.asset(
              'assets/animations/sleeping.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          Text(
            duration > 0 ? formatDuration(duration) : '--',
            style: textTheme.displayLarge!.copyWith(color: colors.onBackground),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            messageFor(level),
            style: textTheme.bodyMedium!.copyWith(
              color: colors.progressColor(level),
            ),
          ),
        ],
      ),
    );
  }
}
