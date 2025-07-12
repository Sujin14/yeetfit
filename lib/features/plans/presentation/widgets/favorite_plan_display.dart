import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/presentation/widgets/plan_list_item.dart';
import '../../../../shared/theme/theme.dart';
import '../../../explore/presentation/providers/explore_providers.dart';
import '../widgets/loading_card_widget.dart';
import '../widgets/error_card_widget.dart';

class FavoritePlansDisplay extends ConsumerWidget {
  const FavoritePlansDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlansAsync = ref.watch(favoritePlansProvider);

    return favoritePlansAsync.when(
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
          : ListView.separated(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final category = plan.type == 'diet' ? 'diet' : 'workouts';
                return PlanListItem(
                  plan: plan,
                  onTap: () {
                    debugPrint(
                      'Favorite Plan tapped: id=${plan.id}, type=${plan.type}, category=$category',
                    );
                    context.push(
                      '/plans/${plan.id}',
                      extra: {'plan': plan, 'category': category},
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
            ),
      loading: () => const LoadingCardWidget(),
      error: (error, _) => ErrorCardWidget(error: error.toString()),
    );
  }
}
