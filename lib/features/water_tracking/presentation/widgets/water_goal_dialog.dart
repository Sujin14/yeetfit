import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/water_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

// Dialog for editing water goal.
class WaterGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const WaterGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<WaterGoalDialog> createState() => _WaterGoalDialogState();
}

class _WaterGoalDialogState extends ConsumerState<WaterGoalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentGoal =
        ref.read(todayWaterProvider(widget.userId)).value?.goalGlasses ?? 8;
    _controller = TextEditingController(text: '$currentGoal');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final provider = waterGoalControllerProvider(widget.userId);
    await ref.read(provider.notifier).submit(_controller.text);
    if (!mounted) return;
    switch (ref.read(provider)) {
      case AsyncData(value: true):
        context.pop();
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
        .watch(waterGoalControllerProvider(widget.userId))
        .isLoading;
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: colors.onSurface);

    return AlertDialog(
      title: Text('Edit Water Goal', style: textStyle),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Glasses per Day',
          hintText: 'Enter number of glasses',
          labelStyle: textStyle.copyWith(
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
          hintStyle: textStyle.copyWith(
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        style: textStyle,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text('Cancel', style: textStyle),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          child: Text(
            'Save',
            style: textStyle.copyWith(color: colors.onPrimary),
          ),
        ),
      ],
    );
  }
}
