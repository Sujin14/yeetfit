import 'package:flutter/material.dart';
import 'package:yeetfit/features/workout_log/presentation/widgets/log_workout_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Today's workout on the dashboard, inset like the other cards.
class DashboardWorkoutCard extends StatelessWidget {
  final String userId;

  const DashboardWorkoutCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: LogWorkoutButton(userId: userId),
    );
  }
}
