import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../../../water_tracking/presentation/providers/water_provider.dart';
import '../../../weight_tracking/presentation/providers/weight_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/goal_card.dart';

class GoalSettingsScreen extends ConsumerWidget {
  const GoalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userInfoControllerProvider);
    final waterGoalAsync = ref.watch(waterGoalProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final weightGoalAsync = ref.watch(weightGoalProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Settings',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: userDataAsync.when(
        data: (userInfo) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GoalCard(
                title: 'Weight Goal',
                icon: Icons.scale,
                goal: weightGoalAsync.when(
                  data: (weightData) => '${weightData.goalWeight} kg',
                  loading: () => userInfo.goalWeight.toString(),
                  error: (_, __) => userInfo.goalWeight.toString(),
                ),
                onEdit: () => ref.read(settingsControllerProvider.notifier).showEditGoalDialog(
                      context: context,
                      label: 'Weight Goal (kg)',
                      initialValue: userInfo.goalWeight.toString(),
                      type: 'Weight',
                    ),
              ),
              SizedBox(height: 16.h),
              GoalCard(
                title: 'Water Goal',
                icon: Icons.water_drop,
                goal: waterGoalAsync.when(
                  data: (goal) => '$goal glasses',
                  loading: () => userInfo.waterGoal?.toString() ?? '8.0',
                  error: (_, __) => userInfo.waterGoal?.toString() ?? '8.0',
                ),
                onEdit: () => ref.read(settingsControllerProvider.notifier).showEditGoalDialog(
                      context: context,
                      label: 'Water Goal (glasses)',
                      initialValue: userInfo.waterGoal?.toString() ?? '8.0',
                      type: 'Water',
                    ),
              ),
              SizedBox(height: 16.h),
              GoalCard(
                title: 'Steps Goal',
                icon: Icons.directions_walk,
                goal: userInfo.stepsGoal?.toString() ?? '2500 steps',
                onEdit: () => ref.read(settingsControllerProvider.notifier).showEditGoalDialog(
                      context: context,
                      label: 'Steps Goal',
                      initialValue: userInfo.stepsGoal?.toString() ?? '2500',
                      type: 'Steps',
                    ),
              ),
              SizedBox(height: 16.h),
              GoalCard(
                title: 'Sleep Goal',
                icon: Icons.bedtime,
                goal: userInfo.sleepGoal?.toString() ?? '8.0 hours',
                onEdit: () => ref.read(settingsControllerProvider.notifier).showEditGoalDialog(
                      context: context,
                      label: 'Sleep Goal (hours)',
                      initialValue: userInfo.sleepGoal?.toString() ?? '8.0',
                      type: 'Sleep',
                    ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
          ),
        ),
      ),
    );
  }
}