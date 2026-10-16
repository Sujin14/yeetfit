import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Dialog for setting weight goal.
class WeightGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const WeightGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<WeightGoalDialog> createState() => _WeightGoalDialogState();
}

class _WeightGoalDialogState extends ConsumerState<WeightGoalDialog> {
  final goalController = TextEditingController();
  final initialController = TextEditingController();
  DateTime? targetDate;

  @override
  void initState() {
    super.initState();
    final goal = ref.read(weightGoalProvider(widget.userId)).value;
    goalController.text = (goal?.goalWeight ?? 70.0).toStringAsFixed(1);
    initialController.text = (goal?.initialWeight ?? 75.0).toStringAsFixed(1);
    targetDate = goal?.targetDate;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Weight Goal',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: colors.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            child: TextField(
              controller: goalController,
              decoration: InputDecoration(
                labelText: 'Goal Weight (kg)',
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderStart),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 250,
            child: TextField(
              controller: initialController,
              decoration: InputDecoration(
                labelText: 'Initial Weight (kg)',
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderStart),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ListTile(
            title: Text(
              'Target Date',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colors.onSurface,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              targetDate != null
                  ? '${targetDate!.day}/${targetDate!.month}/${targetDate!.year}'
                  : 'Select Date',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colors.onSurface,
                fontSize: 14,
              ),
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    targetDate ?? DateTime.now().add(const Duration(days: 180)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => targetDate = date);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colors.onSurface,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final goalWeight = double.tryParse(goalController.text);
            final initialWeight = double.tryParse(initialController.text);
            if (goalWeight != null &&
                initialWeight != null &&
                goalWeight > 0 &&
                initialWeight > 0) {
              ref
                  .read(weightGoalProvider(widget.userId).notifier)
                  .setGoal(goalWeight, initialWeight, targetDate);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter valid weights')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary.withValues(alpha: 0.3),
          ),
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colors.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    goalController.dispose();
    initialController.dispose();
    super.dispose();
  }
}
