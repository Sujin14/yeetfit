import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../data/models/plan_model.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_details_display.dart';

class PlanDetailScreenBody extends ConsumerWidget {
  final Map<String, dynamic> extra;

  const PlanDetailScreenBody({super.key, required this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = extra['plan'] as PlanModel;
    final category = extra['category'] as String?;
    final planAsync = ref.watch(planDetailProvider(extra));

    return planAsync.when(
      data: (updatedPlan) {
        if (updatedPlan == null) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Error',
            ),
            body: Center(
              child: Text(
                'Plan not found',
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['error'],
                  fontSize: 16.sp,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: updatedPlan.title,
            showSettings: true,
            onSettings: () => context.push('/settings'),
            showFavorite: true,
            isFavorite: updatedPlan.isFavorite,
            favoriteColor: updatedPlan.isFavorite
                ? AppTheme.colors['favorite']
                : AppTheme.colors['secondaryText'],
            onFavorite: () async {
              try {
                await ref.read(favoritePlansProvider.notifier).toggleFavorite(
                      updatedPlan.id!,
                      updatedPlan.type,
                      !updatedPlan.isFavorite,
                      context,
                    );
              } catch (e) {
                // SnackBar is handled in FavoritePlansNotifier
              }
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PlanDetailsDisplay(
                      plan: updatedPlan,
                      category: category,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: CustomAppBar(title: plan.title),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: CustomAppBar(title: 'Error'),
        body: Center(
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