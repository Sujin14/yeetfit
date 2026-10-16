import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/sleep_provider.dart';
import 'sleep_entry_sheet.dart';
import 'sleep_time_card.dart';
import 'sleep_time_card_shimmer.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Bedtime and wake-up tiles side by side; tapping either opens the entry dialog.
class SleepTimeCards extends ConsumerWidget {
  final String userId;

  const SleepTimeCards({super.key, required this.userId});

  static String _format(DateTime? time) =>
      time == null ? 'Not set' : DateFormat('h:mm a').format(time);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final sleepAsync = ref.watch(todaySleepProvider(userId));

    void openEntry() => SleepEntrySheet.show(context, userId: userId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: sleepAsync.when(
        data: (sleep) => Row(
          children: [
            Expanded(
              child: SleepTimeCard(
                icon: Icons.bedtime,
                label: 'Bedtime',
                time: _format(sleep?.bedtime),
                onTap: openEntry,
              ),
            ),
            const SizedBox(width: AppSpacing.smd),
            Expanded(
              child: SleepTimeCard(
                icon: Icons.alarm,
                label: 'Wake-up',
                time: _format(sleep?.wakeUpTime),
                onTap: openEntry,
              ),
            ),
          ],
        ),
        loading: () => const SleepTimeCardsShimmer(),
        error: (error, _) => YeetErrorState.compact(
          message: '$error',
          onRetry: () => ref.invalidate(todaySleepProvider(userId)),
        ),
      ),
    );
  }
}
