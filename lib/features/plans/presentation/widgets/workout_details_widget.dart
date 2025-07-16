import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import 'youtube_player_widget.dart';

class WorkoutDetailsWidget extends StatelessWidget {
  final List<dynamic> exercises;

  const WorkoutDetailsWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 16.h),
              YoutubePlayerWidget(videoUrl: videoUrl),
            ],
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
