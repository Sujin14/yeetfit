import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import 'youtube_player_widget.dart';

class WorkoutDetailsWidget extends StatelessWidget {
  final List<dynamic> exercises;

  const WorkoutDetailsWidget({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    // Filter only valid exercises (Map<String, dynamic>)
    final validExercises = exercises.whereType<Map<String, dynamic>>().toList();

    if (validExercises.isEmpty) {
      return Center(
        child: Text(
          'No exercises available',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font16(context),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: validExercises.length,
      itemBuilder: (context, index) {
        final exercise = validExercises[index];

        final name = exercise['name'] ?? 'Unnamed';
        final description = exercise['description'] as String? ?? '';
        final videoUrl = exercise['videoUrl'] as String?;

        final reps = exercise['reps'] ?? 'N/A';
        final repsType = exercise['repsType'] ?? '';
        final sets = exercise['sets']?.toString() ?? 'N/A';

        final rawInstructions = exercise['instructions'];
        final List<String> instructions = (rawInstructions is List)
            ? rawInstructions
                .whereType<Map<String, dynamic>>()
                .map((e) => e['text']?.toString() ?? '')
                .where((text) => text.isNotEmpty)
                .toList()
            : [];

        return Padding(
          padding: EdgeInsets.only(bottom: FixedSizes.box16(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercise ${index + 1}: $name',
                style: AppTheme.textStyles['subheading']?.copyWith(
                      color: AppTheme.colors['primaryText'],
                      fontSize: FixedSizes.font18(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Text(
                'Reps: $reps $repsType',
                style: AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'],
                      fontSize: FixedSizes.font14(context),
                    ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Text(
                'Sets: $sets',
                style: AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['secondaryText'],
                      fontSize: FixedSizes.font14(context),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: FixedSizes.box8(context)),
                Text(
                  'Description: $description',
                  style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['secondaryText'],
                        fontSize: FixedSizes.font14(context),
                      ),
                ),
              ],
              if (instructions.isNotEmpty) ...[
                SizedBox(height: FixedSizes.box8(context)),
                Text(
                  'Instructions:',
                  style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['secondaryText'],
                        fontSize: FixedSizes.font14(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                ...instructions.map(
                  (text) => Padding(
                    padding: EdgeInsets.only(
                        left: FixedSizes.box16(context),
                        top: FixedSizes.box4(context)),
                    child: Text(
                      '- $text',
                      style: AppTheme.textStyles['body']?.copyWith(
                            color: AppTheme.colors['secondaryText'],
                            fontSize: FixedSizes.font14(context),
                          ),
                    ),
                  ),
                ),
              ],
              if (videoUrl != null && videoUrl.isNotEmpty) ...[
                SizedBox(height: FixedSizes.box16(context)),
                // Only render YoutubePlayerWidget if videoId is valid
                Builder(builder: (context) {
                  final videoId =
                      YoutubePlayerController.convertUrlToId(videoUrl.split('?').first);
                  if (videoId != null) {
                    return YoutubePlayerWidget(videoUrl: videoUrl);
                  } else {
                    return Text(
                      'Video unavailable',
                      style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['secondaryText'],
                        fontSize: FixedSizes.font14(context),
                      ),
                    );
                  }
                }),
              ],
            ],
          ),
        );
      },
    );
  }
}
