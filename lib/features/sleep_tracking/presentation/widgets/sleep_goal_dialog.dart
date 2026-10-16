import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/sleep_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Dialog for setting sleep goal.
class SleepGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const SleepGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<SleepGoalDialog> createState() => _SleepGoalDialogState();
}

class _SleepGoalDialogState extends ConsumerState<SleepGoalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentGoal =
        ref.read(todaySleepProvider(widget.userId)).value?.goalHours ?? 8.0;
    _controller = TextEditingController(text: currentGoal.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = sleepGoalControllerProvider(widget.userId);
    await ref.read(provider.notifier).submit(_controller.text);
    if (!mounted) return;
    switch (ref.read(provider)) {
      case AsyncData(value: true):
        Navigator.pop(context);
      case AsyncError(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSaving = ref
        .watch(sleepGoalControllerProvider(widget.userId))
        .isLoading;
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: colors.onPrimary);

    return AlertDialog(
      backgroundColor: colors.secondary.withValues(alpha: 0.3),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Sleep Goal (hours)',
        style: textStyle.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            fillColor: colors.onPrimary.withValues(alpha: 0.6),
            filled: true,
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: textStyle.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colors.onPrimary.withValues(alpha: 0.3),
              ),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: textStyle,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: textStyle),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary.withValues(alpha: 0.8),
          ),
          child: Text('Save', style: textStyle),
        ),
      ],
    );
  }
}
