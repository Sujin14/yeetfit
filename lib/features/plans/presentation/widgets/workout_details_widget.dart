import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import 'youtube_player_widget.dart';

class WorkoutDetailsWidget extends StatelessWidget {
  final List<dynamic> exercises;

  const WorkoutDetailsWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final validExercises = exercises
        .whereType<Map<String, dynamic>>()
        .toList();

    if (validExercises.isEmpty) {
      return Center(
        child: Text(
          'No exercises available',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: 16.sp,
          ) ?? TextStyle(fontSize: 16.sp, color: AppTheme.colors['gray']),
        ),
      );
    }

    return ListView.builder(
      itemCount: validExercises.length,
      itemBuilder: (context, index) {
        final exercise = validExercises[index];
        final name = exercise['name'] ?? 'Unnamed';
        final videoUrl = exercise['videoUrl'] as String?;
        final description = exercise['description'] as String?;
        final reps = exercise['reps'] ?? 'N/A';
        final repsType = exercise['repsType'] ?? '';
        final sets = exercise['sets']?.toString() ?? 'N/A';
        final rawInstructions = exercise['instructions'];
        final List<String> instructions;

        if (rawInstructions is List) {
          instructions = rawInstructions
              .whereType<Map<String, dynamic>>()
              .map((e) => e['text']?.toString() ?? '')
              .where((text) => text.isNotEmpty)
              .toList();
        } else if (rawInstructions is String) {
          instructions = [rawInstructions];
        } else {
          instructions = [];
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercise ${index + 1}: $name',
                style: AppTheme.textStyles['subheading']?.copyWith(
                      color: AppTheme.colors['primaryText'],
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ) ??
                    TextStyle(
                      fontSize: 18.sp,
                      color: AppTheme.colors['black'],
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 8.h),

              Text(
                'Reps: $reps $repsType',
                style: AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'],
                      fontSize: 14.sp,
                    ) ??
                    TextStyle(fontSize: 14.sp, color: AppTheme.colors['gray']),
              ),

              // Sets
              SizedBox(height: 8.h),
              Text(
                'Sets: $sets',
                style: AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ) ??
                    TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.colors['gray'],
                      fontWeight: FontWeight.w500,
                    ),
              ),

              // Description
              if (description != null && description.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  'Description: $description',
                  style: AppTheme.textStyles['body']?.copyWith(
                        color:
                            AppTheme.colors['secondaryText'],
                        fontSize: 14.sp,
                      ) ??
                      TextStyle(fontSize: 14.sp, color: AppTheme.colors['gray']),
                ),
              ],

              // Instructions
              if (instructions.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  'Instructions:',
                  style: AppTheme.textStyles['body']?.copyWith(
                        color:
                            AppTheme.colors['secondaryText'],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ) ??
                      TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.colors['gray'],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                ...instructions.map(
                  (text) => Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 4.h),
                    child: Text(
                      '- $text',
                      style: AppTheme.textStyles['body']?.copyWith(
                            color: AppTheme.colors['secondaryText'],
                            fontSize: 14.sp,
                          ) ??
                          TextStyle(fontSize: 14.sp, color: AppTheme.colors['gray']),
                    ),
                  ),
                ),
              ],
              if (videoUrl != null && videoUrl.isNotEmpty) ...[
                SizedBox(height: 16.h),
                YoutubePlayerWidget(videoUrl: videoUrl),
              ],
            ],
          ),
        );
      },
    );
  }
}
