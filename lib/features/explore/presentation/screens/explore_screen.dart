import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/theme/theme.dart';
import '../providers/explore_providers.dart.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsync = ref.watch(dietPlanProvider);
    final workoutPlanAsync = ref.watch(workoutPlanProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Your Plans',
                style:
                    AppTheme.textStyles['heading']?.copyWith(
                      color: AppTheme.colors['primaryText'] ?? Colors.black,
                      fontSize: 24.sp,
                    ) ??
                    TextStyle(fontSize: 24.sp, color: Colors.black),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView(
                  children: [
                    dietPlanAsync.when(
                      data: (plan) => plan == null
                          ? buildErrorTile('No diet plan available')
                          : buildPlanTile(
                              context: context,
                              title: 'Diet Plan',
                              icon: Icons.restaurant,
                              onTap: () {
                                debugPrint(
                                  'Navigating to diet plan: ${plan.id}, type: ${plan.type}',
                                );
                                context.push('/plans/${plan.id}', extra: plan);
                              },
                            ),
                      loading: () => buildLoadingTile(),
                      error: (error, _) => buildErrorTile(
                        error.toString().contains('PERMISSION_DENIED')
                            ? 'Permission denied: Please check your authentication'
                            : error.toString(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    workoutPlanAsync.when(
                      data: (plan) => plan == null
                          ? buildErrorTile('No workout plan available')
                          : buildPlanTile(
                              context: context,
                              title: 'Workout Plan',
                              icon: Icons.fitness_center,
                              onTap: () {
                                debugPrint(
                                  'Navigating to workout plan: ${plan.id}, type: ${plan.type}',
                                );
                                context.push('/plans/${plan.id}', extra: plan);
                              },
                            ),
                      loading: () => buildLoadingTile(),
                      error: (error, _) => buildErrorTile(
                        error.toString().contains('PERMISSION_DENIED')
                            ? 'Permission denied: Please check your authentication'
                            : error.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlanTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppTheme.colors['cardBackground'] ?? Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: (AppTheme.colors['shadow'] ?? Colors.grey).withOpacity(
                0.1,
              ),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: AppTheme.colors['primaryIcon'] ?? Colors.blue,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildErrorTile(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: (AppTheme.colors['error'] ?? Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 24.sp,
            color: AppTheme.colors['error'] ?? Colors.red,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              message,
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['error'] ?? Colors.red,
                    fontSize: 16.sp,
                  ) ??
                  TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingTile() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.colors['cardBackground'] ?? Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 24.sp,
            color: AppTheme.colors['secondaryIcon'] ?? Colors.grey,
          ),
          SizedBox(width: 16.w),
          Text(
            'Loading...',
            style:
                AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                  fontSize: 16.sp,
                ) ??
                TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
