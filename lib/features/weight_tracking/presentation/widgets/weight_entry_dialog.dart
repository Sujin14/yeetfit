import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';

/// Dialog for entering current weight. Saving is delegated to
/// [WeightSaveController]; the tracking screen closes this dialog and
/// reacts to the result.
class WeightEntryDialog extends ConsumerStatefulWidget {
  final String userId;

  const WeightEntryDialog({super.key, required this.userId});

  @override
  ConsumerState<WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends ConsumerState<WeightEntryDialog> {
  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentWeight =
        ref.read(currentWeightProvider(widget.userId)).value ?? 75.0;
    weightController.text = currentWeight.toStringAsFixed(1);
  }

  void _save() => ref
      .read(weightSaveControllerProvider(widget.userId).notifier)
      .save(weightController.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSaving = ref
        .watch(weightSaveControllerProvider(widget.userId))
        .isLoading;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        'Enter Current Weight',
        style: textTheme.titleLarge!.copyWith(color: colorScheme.onSurface),
      ),
      content: TextField(
        controller: weightController,
        autofocus: true,
        enabled: !isSaving,
        decoration: InputDecoration(
          labelText: 'Current Weight (kg)',
          labelStyle: textTheme.bodyMedium!.copyWith(
            color: colors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colors.borderStart),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        style: textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          child: isSaving
              ? ButtonSpinner(color: colors.onPrimary)
              : Text(
                  'Save',
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.onPrimary,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }
}
