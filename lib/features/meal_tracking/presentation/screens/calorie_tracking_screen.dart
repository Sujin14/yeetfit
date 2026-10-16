import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/food_provider.dart';
import '../widgets/calorie_summary_card.dart';
import '../widgets/macro_summary_row.dart';
import '../widgets/meal_scan_banner.dart';
import '../widgets/meal_scan_button.dart';
import '../widgets/meal_section_list.dart';
import '../widgets/meal_shimmer.dart';
import '../widgets/weekly_chart_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CalorieTrackingScreen extends ConsumerWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to track calories',
              )
            : CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: 'Nutrition',
                    actions: [
                      MealScanButton(
                        onScanned: (meal) => context.push<bool>(
                          TrackingRouteConstants.mealScanResult,
                          extra: meal,
                        ),
                      ),
                      WeeklyChartButton(
                        onPressed: () => context.push(
                          TrackingRouteConstants.weeklyCalorieChart,
                        ),
                      ),
                    ],
                  ),
                  ...switch (ref.watch(nutritionTargetsProvider(userId))) {
                    AsyncValue(hasValue: true) => [
                      SliverToBoxAdapter(
                        child: CalorieSummaryCard(userId: userId),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.smd),
                      ),
                      SliverToBoxAdapter(
                        child: MacroSummaryRow(userId: userId),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.md),
                      ),
                      SliverToBoxAdapter(
                        child: MealScanBanner(
                          onScanned: (meal) => context.push<bool>(
                            TrackingRouteConstants.mealScanResult,
                            extra: meal,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.md),
                      ),
                      SliverToBoxAdapter(
                        child: MealSectionList(
                          userId: userId,
                          onAddFood: (mealType) => context.push(
                            TrackingRouteConstants.foodSearch,
                            extra: mealType,
                          ),
                          onOpenEntry: (item) => context.push(
                            TrackingRouteConstants.nutritionDetails,
                            extra: item,
                          ),
                        ),
                      ),
                    ],
                    AsyncError(:final error) => [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: YeetErrorState(
                          message:
                              'Could not load your nutrition goals: $error',
                          onRetry: () =>
                              ref.invalidate(userDocumentProvider(userId)),
                        ),
                      ),
                    ],
                    _ => [
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: AppSpacing.sm),
                          child: MealShimmer(),
                        ),
                      ),
                    ],
                  },
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }
}
