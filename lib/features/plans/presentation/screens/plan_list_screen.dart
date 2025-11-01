import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_list_item.dart';

class PlanListScreen extends ConsumerWidget {
  final String category;

  const PlanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(
      category == 'diet' ? allDietPlansProvider : allWorkoutPlansProvider,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors['transparent'],
        elevation: 0,
        centerTitle: true,
        title: Text(
          category == 'diet' ? 'Diet Plans' : 'Workout Plans',
          style: GoogleFonts.roboto(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ),
      body: SafeArea(
        child: plansAsync.when(
          data: (plans) {
            if (plans.isEmpty) {
              return Center(
                child: Text(
                  'No ${category == 'diet' ? 'diet' : 'workout'} plans have been assigned.',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
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
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                color: AppTheme.colors['error'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}