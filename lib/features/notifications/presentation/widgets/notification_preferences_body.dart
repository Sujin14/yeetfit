import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../domain/entities/notification_preferences.dart';
import '../providers/notification_preferences_provider.dart';
import 'notification_preferences_shimmer.dart';
import 'notification_toggle_tile.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class NotificationPreferencesBody extends ConsumerWidget {
  final String userId;

  const NotificationPreferencesBody({super.key, required this.userId});

  static (IconData, String, String) _describe(NotificationPreferenceType type) {
    return switch (type) {
      NotificationPreferenceType.waterReminder => (
        Icons.water_drop_outlined,
        'Water reminders',
        "A nudge after 11am if you haven't logged any water",
      ),
      NotificationPreferenceType.streakAlerts => (
        Icons.local_fire_department_outlined,
        'Streak alerts',
        'Celebrate tracking streaks of 3 days or more',
      ),
      NotificationPreferenceType.dailyTips => (
        Icons.lightbulb_outline,
        'Daily tips',
        'Fitness and nutrition tips from Yeetfit',
      ),
      NotificationPreferenceType.challengeUpdates => (
        Icons.emoji_events_outlined,
        'Challenge updates',
        'News about community challenges and leaderboards',
      ),
      NotificationPreferenceType.coachMessages => (
        Icons.chat_bubble_outline,
        'Coach messages',
        'New messages from your coach',
      ),
      NotificationPreferenceType.liveSessions => (
        Icons.live_tv_outlined,
        'Live sessions',
        'When a coach schedules a new group session',
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final provider = notificationPreferencesControllerProvider(userId);
    final preferencesAsync = ref.watch(provider);

    return preferencesAsync.when(
      loading: () => NotificationPreferencesShimmer(
        count: NotificationPreferenceType.values.length,
      ),
      error: (_, _) => YeetErrorState(
        message: 'Could not load notification settings.',
        onRetry: () => ref.read(provider.notifier).load(),
      ),
      data: (preferences) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: NotificationPreferenceType.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.smd),
        itemBuilder: (context, index) {
          final type = NotificationPreferenceType.values[index];
          final (icon, title, subtitle) = _describe(type);
          return NotificationToggleTile(
            icon: icon,
            title: title,
            subtitle: subtitle,
            value: preferences.isEnabled(type),
            onChanged: (enabled) async {
              final messenger = ScaffoldMessenger.of(context);
              final error = await ref
                  .read(provider.notifier)
                  .toggle(type, enabled);
              if (error != null) {
                messenger.showSnackBar(SnackBar(content: Text(error)));
              }
            },
          );
        },
      ),
    );
  }
}
