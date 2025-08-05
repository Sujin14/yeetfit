import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../../../water_tracking/presentation/providers/water_provider.dart';
import '../../../weight_tracking/presentation/providers/weight_provider.dart';

class GoalSettingsScreen extends ConsumerWidget {
  const GoalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userDataAsync = ref.watch(userInfoControllerProvider);
    final waterGoalAsync = ref.watch(waterGoalProvider(userId));
    final weightGoalAsync = ref.watch(weightGoalProvider(userId));

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userDataAsync.when(
        data: (userInfo) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                _buildGoalCard(
                  context: context,
                  ref: ref,
                  userId: userId,
                  title: 'Weight Goal',
                  icon: Icons.scale,
                  goal: weightGoalAsync.when(
                    data: (weightData) => '${weightData.goalWeight} kg',
                    loading: () => userInfo.goalWeight.toString(),
                    error: (_, __) => userInfo.goalWeight.toString(),
                  ),
                  onEdit: () async {
                    final controller = TextEditingController(
                      text: userInfo.goalWeight.toString(),
                    );
                    final result = await showDialog<double>(
                      context: context,
                      builder: (context) => _buildEditDialog(context, 'Weight Goal (kg)', controller),
                    );
                    if (result != null) {
                      await ref.read(setWeightGoalProvider).call(
                            userId,
                            result,
                            userInfo.currentWeight,
                            null,
                          );
                      ref.read(userInfoControllerProvider.notifier).updateWeights(
                            goal: result,
                            context: context,
                          );
                      await ref.read(userInfoControllerProvider.notifier).saveUserData(context);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                _buildGoalCard(
                  context: context,
                  ref: ref,
                  userId: userId,
                  title: 'Water Goal',
                  icon: Icons.water_drop,
                  goal: waterGoalAsync.when(
                    data: (goal) => '$goal glasses',
                    loading: () => userInfo.waterGoal?.toString() ?? '8.0',
                    error: (_, __) => userInfo.waterGoal?.toString() ?? '8.0',
                  ),
                  onEdit: () async {
                    final controller = TextEditingController(
                      text: userInfo.waterGoal?.toString() ?? '8.0',
                    );
                    final result = await showDialog<double>(
                      context: context,
                      builder: (context) => _buildEditDialog(context, 'Water Goal (glasses)', controller),
                    );
                    if (result != null) {
                      await ref.read(setWaterGoalProvider).call(userId, result.toInt());
                      ref.read(userInfoControllerProvider.notifier).updateWaterGoal(result, context);
                      await ref.read(userInfoControllerProvider.notifier).saveUserData(context);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                _buildGoalCard(
                  context: context,
                  ref: ref,
                  userId: userId,
                  title: 'Steps Goal',
                  icon: Icons.directions_walk,
                  goal: userInfo.stepsGoal?.toString() ?? '2500 steps',
                  onEdit: () async {
                    final controller = TextEditingController(
                      text: userInfo.stepsGoal?.toString() ?? '2500',
                    );
                    final result = await showDialog<double>(
                      context: context,
                      builder: (context) => _buildEditDialog(context, 'Steps Goal', controller),
                    );
                    if (result != null) {
                      ref.read(userInfoControllerProvider.notifier).updateStepsGoal(result, context);
                      await ref.read(userInfoControllerProvider.notifier).saveUserData(context);
                    }
                  },
                ),
                SizedBox(height: 16.h),
                _buildGoalCard(
                  context: context,
                  ref: ref,
                  userId: userId,
                  title: 'Sleep Goal',
                  icon: Icons.bedtime,
                  goal: userInfo.sleepGoal?.toString() ?? '8.0 hours',
                  onEdit: () async {
                    final controller = TextEditingController(
                      text: userInfo.sleepGoal?.toString() ?? '8.0',
                    );
                    final result = await showDialog<double>(
                      context: context,
                      builder: (context) => _buildEditDialog(context, 'Sleep Goal (hours)', controller),
                    );
                    if (result != null) {
                      ref.read(userInfoControllerProvider.notifier).updateSleepGoal(result, context);
                      await ref.read(userInfoControllerProvider.notifier).saveUserData(context);
                    }
                  },
                ),
                SizedBox(height: 60.h),
              ],
            ),
          );
        },
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

  Widget _buildGoalCard({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String title,
    required IconData icon,
    required String goal,
    required VoidCallback onEdit,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100.h,
      borderRadius: 16.r,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          AppTheme.colors['navigationAccent']!.withOpacity(0.1),
          AppTheme.colors['navigationAccent']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [AppTheme.colors['gradientTextStart']!, AppTheme.colors['gradientTextEnd']!],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.colors['primaryText'], size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    goal,
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppTheme.colors['primaryText'], size: 20.sp),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDialog(BuildContext context, String label, TextEditingController controller) {
    return AlertDialog(
      backgroundColor: AppTheme.colors['lightBackground'],
      title: Text(
        'Edit $label',
        style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
      ),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        keyboardType: TextInputType.number,
        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText'])),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, double.tryParse(controller.text)),
          child: Text('Save', style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText'])),
        ),
      ],
    );
  }
}