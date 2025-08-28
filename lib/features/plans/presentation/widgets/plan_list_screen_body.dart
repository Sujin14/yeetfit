import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_list_item.dart';

class PlanListScreenBody extends ConsumerWidget {
  final String category;

  const PlanListScreenBody({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(category == 'diet' ? dietPlanProvider : workoutPlanProvider);

    return SafeArea(
      child: plansAsync.when(
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Text(
                'No ${category == 'diet' ? 'diet' : 'workout'} plans available',
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.8),
                  fontSize: 16.sp,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            itemCount: 1, // Single plan as per provider
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: PlanListItem(
                  plan: plan,
                  onTap: () {
                    context.push(
                      '/plans/$category/${plan.id}',
                      extra: {'plan': plan, 'category': category},
                    );
                  },
                ),
              );
            },
          );
        },
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
      ),
    );
  }
}