import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import '../providers/sleep_provider.dart';
import 'sleep_duration_pill.dart';
import 'sleep_time_picker_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Bottom sheet for logging today's bedtime and wake-up time.
class SleepEntrySheet extends ConsumerWidget {
  final String userId;

  const SleepEntrySheet({super.key, required this.userId});

  /// Near-opaque sheet over a dark barrier so nothing behind bleeds through.
  static Future<void> show(BuildContext context, {required String userId}) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => SleepEntrySheet(userId: userId),
    );
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime? initial) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final form = sleepEntryFormProvider(userId);
    // Re-checked here so a second tap in the same frame can't pop twice.
    if (ref.read(form).isSubmitting) return;
    final error = await ref.read(form.notifier).submit();
    if (!context.mounted) return;
    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final form = ref.watch(sleepEntryFormProvider(userId));
    final notifier = ref.read(sleepEntryFormProvider(userId).notifier);
    final duration = form.sleepDuration;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.smd,
        AppSpacing.screenEdge,
        MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colors.textSecondary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Log Sleep',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
          ),
          const SizedBox(height: AppSpacing.md),
          SleepTimePickerRow(
            icon: Icons.bedtime_outlined,
            iconColor: colors.secondary,
            label: 'Bedtime',
            time: form.bedtime,
            onTap: () async {
              final time = await _pickTime(context, form.bedtime);
              if (time != null) notifier.setBedtime(time);
            },
          ),
          const SizedBox(height: AppSpacing.smd),
          SleepTimePickerRow(
            icon: Icons.alarm,
            iconColor: colors.primary,
            label: 'Wake up',
            time: form.wakeUpTime,
            onTap: () async {
              final time = await _pickTime(context, form.wakeUpTime);
              if (time != null) notifier.setWakeUpTime(time);
            },
          ),
          if (duration != null) ...[
            const SizedBox(height: AppSpacing.md),
            SleepDurationPill(duration: duration),
          ],
          const SizedBox(height: 20),
          GradientButton(
            label: 'Save',
            isLoading: form.isSubmitting,
            onPressed: () => _submit(context, ref),
          ),
        ],
      ),
    );
  }
}
