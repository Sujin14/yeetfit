import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_log_provider.dart';

class ManualFoodEntryDialog extends ConsumerStatefulWidget {
  final String userId;
  final String mealType;

  const ManualFoodEntryDialog({
    super.key,
    required this.userId,
    required this.mealType,
  });

  @override
  ConsumerState<ManualFoodEntryDialog> createState() =>
      _ManualFoodEntryDialogState();
}

class _ManualFoodEntryDialogState extends ConsumerState<ManualFoodEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = '';
  double _calories = 0.0;
  double _protein = 0.0;
  double _fat = 0.0;
  double _carbs = 0.0;
  double _fiber = 0.0;
  double _quantity = 100.0;

  Widget _numberField({
    required String label,
    required String emptyMessage,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return emptyMessage;
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final added = await ref
        .read(foodLogControllerProvider.notifier)
        .addToLog(
          userId: widget.userId,
          item: FoodItem(
            date: StreakService.todayKey(),
            mealType: widget.mealType,
            foodName: _foodName.trim(),
            calories: _calories,
            protein: _protein,
            fat: _fat,
            carbs: _carbs,
            fiber: _fiber,
            quantity: _quantity,
          ),
        );
    if (!mounted) return;
    if (added) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't add $_foodName. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSaving = ref.watch(foodLogControllerProvider).isLoading;
    return AlertDialog(
      title: Text('Add Food for ${widget.mealType}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Food Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a food name'
                    : null,
                onChanged: (value) => _foodName = value,
              ),
              _numberField(
                label: 'Quantity (g)',
                emptyMessage: 'Please enter quantity',
                onChanged: (value) =>
                    _quantity = double.tryParse(value) ?? 100.0,
              ),
              _numberField(
                label: 'Calories (kcal)',
                emptyMessage: 'Please enter calories',
                onChanged: (value) => _calories = double.tryParse(value) ?? 0.0,
              ),
              _numberField(
                label: 'Protein (g)',
                emptyMessage: 'Please enter protein amount',
                onChanged: (value) => _protein = double.tryParse(value) ?? 0.0,
              ),
              _numberField(
                label: 'Fat (g)',
                emptyMessage: 'Please enter fat amount',
                onChanged: (value) => _fat = double.tryParse(value) ?? 0.0,
              ),
              _numberField(
                label: 'Carbs (g)',
                emptyMessage: 'Please enter carbs amount',
                onChanged: (value) => _carbs = double.tryParse(value) ?? 0.0,
              ),
              _numberField(
                label: 'Fiber (g)',
                emptyMessage: 'Please enter fiber amount',
                onChanged: (value) => _fiber = double.tryParse(value) ?? 0.0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isSaving ? null : _submit,
          child: isSaving
              ? ButtonSpinner(color: colors.primary)
              : const Text('Add'),
        ),
      ],
    );
  }
}
