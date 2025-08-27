// features/dashboard/presentation/widgets/meal_tracking_card.dart
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class MealTrackingCard extends ConsumerWidget {
  final Map<String, dynamic>? progress;
  final String userId;
  final bool isLoading;

  const MealTrackingCard({
    super.key,
    required this.progress,
    required this.userId,
    this.isLoading = false,
  });

  const MealTrackingCard.loading({
    super.key,
    this.progress,
    required this.userId,
  }) : isLoading = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
        highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
        child: _buildShimmerCard(context),
      );
    }

    return _buildCardContent(context);
  }

  Widget _buildCardContent(BuildContext context) {
    // If progress is null, show loading-like placeholder
    final data = progress ?? {};
    final calories = (data['calories']?.toDouble() ?? 0.0);
    final caloriesGoal = (data['caloriesGoal']?.toDouble() ?? 3500.0);
    final protein = (data['protein']?.toDouble() ?? 0.0);
    final proteinGoal = (data['proteinGoal']?.toDouble() ?? 150.0);
    final carbs = (data['carbs']?.toDouble() ?? 0.0);
    final carbsGoal = (data['carbsGoal']?.toDouble() ?? 300.0);
    final fat = (data['fat']?.toDouble() ?? 0.0);
    final fatGoal = (data['fatGoal']?.toDouble() ?? 70.0);

    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/modal/food', extra: userId),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: FixedSizes.box100(context) * 3, // ~300.h
        borderRadius: FixedSizes.borderRadius(context) / 1.5,
        blur: 10,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colors['navigationAccent']!.withOpacity(0.1),
            AppTheme.colors['navigationAccent']!.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppTheme.colors['gradientTextStart']!,
            AppTheme.colors['gradientTextEnd']!,
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
        child: Padding(
          padding: EdgeInsets.all(FixedSizes.box12(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meal Tracking',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.font16(context),
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: FixedSizes.box50(context) * 1.2,
                                  lineWidth: FixedSizes.box8(context) / 2,
                                  percent: (calories / caloriesGoal).clamp(0.0, 1.0),
                                  progressColor: AppTheme.colors['caloriesProgress'],
                                  backgroundColor:
                                      AppTheme.colors['secondaryText']!.withOpacity(0.2),
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                                CircularPercentIndicator(
                                  radius: FixedSizes.box50(context) * 0.9,
                                  lineWidth: FixedSizes.box8(context) / 2,
                                  percent: (protein / proteinGoal).clamp(0.0, 1.0),
                                  progressColor: AppTheme.colors['proteinProgress'],
                                  backgroundColor:
                                      AppTheme.colors['secondaryText']!.withOpacity(0.2),
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                                CircularPercentIndicator(
                                  radius: FixedSizes.box50(context) * 0.6,
                                  lineWidth: FixedSizes.box6(context),
                                  percent: (carbs / carbsGoal).clamp(0.0, 1.0),
                                  progressColor: AppTheme.colors['carbsProgress'],
                                  backgroundColor:
                                      AppTheme.colors['secondaryText']!.withOpacity(0.2),
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                                CircularPercentIndicator(
                                  radius: FixedSizes.box50(context) * 0.3,
                                  lineWidth: FixedSizes.box6(context),
                                  percent: (fat / fatGoal).clamp(0.0, 1.0),
                                  progressColor: AppTheme.colors['fatProgress'],
                                  backgroundColor:
                                      AppTheme.colors['secondaryText']!.withOpacity(0.2),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  center: Icon(
                                    Icons.local_fire_department,
                                    size: FixedSizes.font12(context) * 1.0,
                                    color: AppTheme.colors['primaryText'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
                            child: Text(
                              'Eat balanced meals with whole foods!',
                              style: AppTheme.textStyles['body']!.copyWith(
                                fontSize: FixedSizes.font14(context),
                                color: AppTheme.colors['primaryText'],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: FixedSizes.box16(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroContainer(
                          context,
                          'Calories',
                          '${calories.toInt()}/${caloriesGoal.toInt()} kcal',
                          AppTheme.colors['caloriesProgress']!,
                        ),
                        _buildMacroContainer(
                          context,
                          'Protein',
                          '${protein.toInt()}/${proteinGoal.toInt()} g',
                          AppTheme.colors['proteinProgress']!,
                        ),
                        _buildMacroContainer(
                          context,
                          'Carbs',
                          '${carbs.toInt()}/${carbsGoal.toInt()} g',
                          AppTheme.colors['carbsProgress']!,
                        ),
                        _buildMacroContainer(
                          context,
                          'Fat',
                          '${fat.toInt()}/${fatGoal.toInt()} g',
                          AppTheme.colors['fatProgress']!,
                        ),
                      ],
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

  Widget _buildMacroContainer(BuildContext context, String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: FixedSizes.box50(context) * 1.0,
          height: FixedSizes.box50(context) * 1.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Center(
            child: Text(
              value.split('/')[0],
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: FixedSizes.font16(context),
                color: AppTheme.colors['primaryText'],
              ),
            ),
          ),
        ),
        SizedBox(height: FixedSizes.box8(context)),
        Text(
          title,
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: FixedSizes.font12(context),
            color: AppTheme.colors['secondaryText'],
          ),
        ),
        Text(
          value,
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: FixedSizes.font12(context),
            color: AppTheme.colors['secondaryText'],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: FixedSizes.box100(context) * 3,
      borderRadius: FixedSizes.borderRadius(context) / 1.5,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!.withOpacity(0.1),
          AppTheme.colors['navigationAccent']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['gradientTextStart']!,
          AppTheme.colors['gradientTextEnd']!,
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
      child: Padding(
        padding: EdgeInsets.all(FixedSizes.box12(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: FixedSizes.box100(context), height: FixedSizes.box12(context), color: AppTheme.colors['white']),
            SizedBox(height: FixedSizes.box6(context)),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: FixedSizes.box100(context) * 1.2,
                            height: FixedSizes.box100(context) * 1.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.colors['white'],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
                          child: Container(
                            width: double.infinity,
                            height: FixedSizes.box40(context),
                            color: AppTheme.colors['white'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: FixedSizes.box20(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      4,
                      (_) => Container(
                        width: FixedSizes.box35(context),
                        height: FixedSizes.box35(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.colors['white'],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
