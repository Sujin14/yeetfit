import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Dialog for setting steps goal.
class StepsGoalDialog extends ConsumerStatefulWidget {
  final String userId;
  final int initialGoal;

  const StepsGoalDialog({
    super.key,
    required this.userId,
    required this.initialGoal,
  });

  @override
  ConsumerState<StepsGoalDialog> createState() => _StepsGoalDialogState();
}

class _StepsGoalDialogState extends ConsumerState<StepsGoalDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.initialGoal}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDesktop = MediaQuery.sizeOf(context).width >= 600;
    return AlertDialog(
      backgroundColor: colors.background,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Steps Goal',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: isDesktop ? 18 : 20,
          color: colors.onBackground.withValues(alpha: 0.8),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter goal steps (e.g., 10000)',
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: colors.onBackground.withValues(alpha: 0.7),
              fontSize: isDesktop ? 14 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colors.onBackground.withValues(alpha: 0.8),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: colors.onBackground.withValues(alpha: 0.7),
            fontSize: isDesktop ? 14 : 16,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: colors.onBackground.withValues(alpha: 0.8),
              fontSize: isDesktop ? 14 : 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(_controller.text);
            if (newGoal != null && newGoal > 0) {
              ref
                  .read(stepsGoalProvider(widget.userId).notifier)
                  .setGoal(newGoal);
              context.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid number')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary.withValues(alpha: 0.3),
          ),
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: isDesktop ? 14 : 16,
            ),
          ),
        ),
      ],
    );
  }
}
