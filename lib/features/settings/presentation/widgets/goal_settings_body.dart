import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/goal_card.dart';

class GoalSettingsBody extends ConsumerWidget {
  const GoalSettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userInfoControllerProvider);

    return userDataAsync.when(
      data: (userInfo) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set Your Fitness Goal',
              style: AppTheme.textStyles['subheading']!.copyWith(
                fontSize: 24.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            SizedBox(height: 16.h),
            GoalCard(
              title: 'Fitness Goal',
              selectedGoal: userInfo.goal.isNotEmpty ? userInfo.goal : 'weight loss',
              onGoalSelected: (newGoal) {
                if (newGoal != null) {
                  ref.read(settingsControllerProvider.notifier).updateFitnessGoal(
                        context: context,
                        goal: newGoal,
                      );
                  context.pop();
                }
              },
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['error'],
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}