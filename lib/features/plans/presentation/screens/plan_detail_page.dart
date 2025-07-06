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

class PlanDetailPage extends ConsumerWidget {
  final PlanModel plan;

  const PlanDetailPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PlanDetailPage: planId=${plan.id}, type=${plan.type}');
    return YoutubePlayerScaffold(
      controller: YoutubePlayerController(),
      builder: (context, child) => Scaffold(
        appBar: CustomAppBar(
          title: plan.title,
          showLogout: false,
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
                        TextStyle(color: Colors.black),
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
                        TextStyle(color: Colors.black),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.details['description'] != null &&
                    plan.details['description'].isNotEmpty) ...[
                  Text(
                    'Description: ${plan.details['description']}',
                    style:
                        AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                          fontSize: 16.sp,
                        ) ??
                        TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                  SizedBox(height: 16.h),
                ],
                Expanded(
                  child: plan.type == 'diet'
                      ? buildDietDetails(plan.details['meals'] ?? [])
                      : buildWorkoutDetails(plan.details['exercises'] ?? []),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDietDetails(List<dynamic> meals) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals available',
          style:
              AppTheme.textStyles['body']?.copyWith(
                color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                fontSize: 16.sp,
              ) ??
              TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index] as Map<String, dynamic>;
        final foods = meal['foods'] as List<dynamic>? ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal ${index + 1}: ${meal['name'] ?? 'Unnamed'}',
              style:
                  AppTheme.textStyles['subheading']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            ...foods.asMap().entries.map((entry) {
              final food = entry.value as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${food['name'] ?? 'Unknown'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['primaryText'] ?? Colors.black,
                            fontSize: 16.sp,
                          ) ??
                          TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    Text(
                      'Quantity: ${food['quantity'] ?? 'N/A'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['secondaryText'] ?? Colors.grey,
                            fontSize: 14.sp,
                          ) ??
                          TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    Text(
                      'Calories: ${food['calories'] ?? 'N/A'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['secondaryText'] ?? Colors.grey,
                            fontSize: 14.sp,
                          ) ??
                          TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    if (food['description'] != null &&
                        food['description'].isNotEmpty)
                      Text(
                        'Description: ${food['description']}',
                        style:
                            AppTheme.textStyles['body']?.copyWith(
                              color:
                                  AppTheme.colors['secondaryText'] ??
                                  Colors.grey,
                              fontSize: 14.sp,
                            ) ??
                            TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Widget buildWorkoutDetails(List<dynamic> exercises) {
    if (exercises.isEmpty) {
      return Center(
        child: Text(
          'No exercises available',
          style:
              AppTheme.textStyles['body']?.copyWith(
                color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                fontSize: 16.sp,
              ) ??
              TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index] as Map<String, dynamic>;
        final videoUrl = exercise['videoUrl'] as String?;
        final description = exercise['description'] as String?;
        final instructions = exercise['instructions'] as String?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise ${index + 1}: ${exercise['name'] ?? 'Unnamed'}',
              style:
                  AppTheme.textStyles['subheading']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Reps: ${exercise['reps'] ?? 'N/A'} ${exercise['repsType'] ?? ''}',
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                    fontSize: 14.sp,
                  ) ??
                  TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            Text(
              'Sets: ${exercise['sets'] ?? 'N/A'}',
              style:
                  AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                    fontSize: 14.sp,
                  ) ??
                  TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            if (description != null && description.isNotEmpty)
              Text(
                'Description: $description',
                style:
                    AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                      fontSize: 14.sp,
                    ) ??
                    TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            if (instructions != null && instructions.isNotEmpty)
              Text(
                'Instructions: $instructions',
                style:
                    AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                      fontSize: 14.sp,
                    ) ??
                    TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            if (videoUrl != null && videoUrl.isNotEmpty) ...[
              SizedBox(height: 8.h),
              SizedBox(
                height: 200.h,
                child: YoutubePlayer(
                  controller: YoutubePlayerController.fromVideoId(
                    videoId:
                        YoutubePlayerController.convertUrlToId(videoUrl) ?? '',
                    autoPlay: false,
                    params: const YoutubePlayerParams(
                      showControls: true,
                      showFullscreenButton: true,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
