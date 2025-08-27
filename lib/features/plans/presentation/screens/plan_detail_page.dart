import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/models/plan_model.dart';
import '../providers/plan_provider.dart';
import '../widgets/plan_details_display.dart';

class PlanDetailPage extends ConsumerWidget {
  final Map<String, dynamic> extra;

  const PlanDetailPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = extra['plan'] as PlanModel;
    final category = extra['category'] as String?;
    final onUnfavorite = extra['onUnfavorite'] as VoidCallback?;

    final planAsync = ref.watch(planDetailProvider(extra));

    return planAsync.when(
      data: (updatedPlan) {
        if (updatedPlan == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Error',
                style: AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['primaryText'],
                ),
              ),
            ),
            body: Center(
              child: Text(
                'Plan not found',
                style: AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['error'],
                  fontSize: FixedSizes.font16(context),
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
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      updatedPlan.isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                      style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['primaryText'],
                      ),
                    ),
                    backgroundColor: AppTheme.colors['primaryButton'],
                  ),
                );
                if (!updatedPlan.isFavorite && onUnfavorite != null) {
                  onUnfavorite();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString().contains('PERMISSION_DENIED')
                          ? 'Permission denied: Only admins can update plans'
                          : 'Error: $e',
                      style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['primaryText'],
                      ),
                    ),
                    backgroundColor: AppTheme.colors['error'],
                  ),
                );
              }
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: FixedSizes.box16(context),
                vertical: FixedSizes.box16(context),
              ),
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
        appBar: AppBar(
          title: Text(
            'Error',
            style: AppTheme.textStyles['body']?.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Error: $error',
            style: AppTheme.textStyles['body']?.copyWith(
              color: AppTheme.colors['error'],
              fontSize: FixedSizes.font16(context),
            ),
          ),
        ),
      ),
    );
  }
}
