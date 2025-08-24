import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_list_item.dart';
import '../widgets/loading_card_widget.dart';
import '../widgets/error_card_widget.dart';

class FavoritePlansDisplay extends ConsumerWidget {
  const FavoritePlansDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlansState = ref.watch(favoritePlansProvider);

    if (favoritePlansState.isLoading) {
      return const LoadingCardWidget();
    }

    if (favoritePlansState.error != null) {
      return ErrorCardWidget(error: favoritePlansState.error!);
    }

    final plans = favoritePlansState.plans;

    if (plans.isEmpty) {
      return Center(
        child: Text(
          'No favorite plans',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return ListView.separated(
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
              '/plans/$category/${plan.id}',
              extra: {
                'plan': plan,
                'category': category,
                'onUnfavorite': () {
                  if (!plan.isFavorite) {
                    context.go('/favorites');
                  }
                },
              },
            );
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
    );
  }
}