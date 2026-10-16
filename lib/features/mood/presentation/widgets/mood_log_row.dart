import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import '../../domain/entities/mood_entry.dart';
import '../providers/mood_provider.dart';
import 'mood_emoji_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// One-tap daily mood log for the dashboard.
class MoodLogRow extends ConsumerWidget {
  static const List<String> emojis = ['😔', '😕', '😐', '🙂', '😄'];

  final String userId;

  const MoodLogRow({super.key, required this.userId});

  Future<void> _logMood(BuildContext context, WidgetRef ref, int score) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(moodDataSourceProvider)
          .saveEntry(userId, MoodEntry.today(score));
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Mood logged ✓'),
            duration: Duration(seconds: 2),
          ),
        );
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not log mood: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final moodAsync = ref.watch(todayMoodProvider(userId));
    final selectedScore = moodAsync.value?.score;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < emojis.length; index++)
                  if (moodAsync.isLoading && !moodAsync.hasValue)
                    const ShimmerBox(
                      width: MoodEmojiButton.size,
                      height: MoodEmojiButton.size,
                      borderRadius: MoodEmojiButton.size / 2,
                    )
                  else
                    MoodEmojiButton(
                      emoji: emojis[index],
                      isSelected: selectedScore == index + 1,
                      onTap: () {
                        if (selectedScore != index + 1) {
                          _logMood(context, ref, index + 1);
                        }
                      },
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
