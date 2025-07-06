import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../explore/presentation/widgets/plan_card.dart';
import '../providers/plan_providers.dart';
import '../widgets/plan_list_item.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlansAsync = ref.watch(favoritePlansProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: favoritePlansAsync.when(
        data: (plans) => plans.isEmpty
            ? Center(
                child: Text(
                  'No favorite plans',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['secondaryText'],
                    fontSize: 16.sp,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return buildPlanListItem(
                    context: context,
                    plan: plan,
                    onTap: () => context.push('/plans/${plan.id}', extra: plan),
                  );
                },
              ),
        loading: buildLoadingCard,
        error: (error, _) => buildErrorCard(error.toString()),
      ),
    );
  }
}
