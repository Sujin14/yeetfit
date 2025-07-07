import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../explore/presentation/providers/explore_providers.dart.dart';
import '../../data/models/plan_model.dart';
import '../providers/plan_providers.dart';
import '../widgets/plan_details_display.dart';

class PlanDetailPage extends ConsumerWidget {
  final Map<String, dynamic> extra;

  const PlanDetailPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = extra['plan'] as PlanModel;
    final category = extra['category'] as String?;
    debugPrint('PlanDetailPage: plan.type=${plan.type}, category=$category');
    return YoutubePlayerScaffold(
      controller: YoutubePlayerController(),
      builder: (context, child) => Scaffold(
        appBar: CustomAppBar(
          title: plan.title,
          showSettings: true,
          onSettings: () => context.push('/settings'),
          showFavorite: true,
          isFavorite: plan.isFavorite,
          onFavorite: () async {
            try {
              await ref
                  .read(toggleFavoriteUseCaseProvider)
                  .execute(plan.id!, plan.type, !plan.isFavorite);
              ref.invalidate(dietPlanProvider);
              ref.invalidate(workoutPlanProvider);
              ref.invalidate(favoritePlansProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    plan.isFavorite
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                    style:
                        AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                        ) ??
                        const TextStyle(color: Colors.black),
                  ),
                  backgroundColor:
                      AppTheme.colors['primaryButton'] ?? Colors.blue,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString().contains('PERMISSION_DENIED')
                        ? 'Permission denied: Only admins can update plans'
                        : 'Error: $e',
                    style:
                        AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                        ) ??
                        const TextStyle(color: Colors.black),
                  ),
                  backgroundColor: AppTheme.colors['error'] ?? Colors.red,
                ),
              );
            }
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: PlanDetailsDisplay(plan: plan, category: category),
          ),
        ),
      ),
    );
  }
}
