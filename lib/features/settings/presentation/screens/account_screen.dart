import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../providers/settings_provider.dart';
import '../widgets/basic_info_card.dart';
import '../widgets/food_preferences_card.dart';
import '../widgets/goal_card.dart';
import '../widgets/profile_card.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userInfoControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: userDataAsync.when(
        data: (userInfo) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: ProfileCard(userInfo: userInfo)),
              SizedBox(height: 24.h),
              BasicInfoCard(onTap: () => context.push('/basic-information')),
              SizedBox(height: 16.h),
              GoalCard(
                title: 'Weight Goal',
                icon: Icons.scale,
                goal: '${userInfo.goalWeight} kg',
                onEdit: () => ref.read(settingsControllerProvider.notifier).showEditGoalDialog(
                      context: context,
                      label: 'Weight Goal (kg)',
                      initialValue: userInfo.goalWeight.toString(),
                      type: 'Weight',
                    ),
              ),
              SizedBox(height: 16.h),
              FoodPreferencesCard(onTap: () => context.push('/food-preferences')),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: isSaving ? null : () => ref.read(settingsControllerProvider.notifier).logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors['error'],
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: isSaving
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: AppTheme.colors['onSurfaceDark'],
                        ),
                      )
                    : Text(
                        'Logout',
                        style: AppTheme.textStyles['body']!.copyWith(
                          color: AppTheme.colors['onSurfaceDark'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
        ),
      ),
    );
  }
}