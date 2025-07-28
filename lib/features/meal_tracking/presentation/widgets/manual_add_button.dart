import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/food_provider.dart';

class ManualAddButton extends ConsumerWidget {
  final String mealType;

  const ManualAddButton({super.key, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return GlassmorphicContainer(
      color: AppTheme.colors['indigo']!,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                _ManualFoodEntryDialog(userId: userId, mealType: mealType),
          );
        },
        backgroundColor: AppTheme.colors['transparent'],
        foregroundColor: AppTheme.colors['onSurface'],
        elevation: 0,
        icon: const Icon(Icons.add),
        label: Text(
          'Add Food',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _ManualFoodEntryDialog extends ConsumerStatefulWidget {
  final String userId;
  final String mealType;

  const _ManualFoodEntryDialog({required this.userId, required this.mealType});

  @override
  _ManualFoodEntryDialogState createState() => _ManualFoodEntryDialogState();
}

class _ManualFoodEntryDialogState
    extends ConsumerState<_ManualFoodEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = '';
  double _calories = 0.0;
  double _protein = 0.0;
  double _fat = 0.0;
  double _carbs = 0.0;
  double _fiber = 0.0;

  @override
  Widget build(BuildContext context) {
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _foodName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _calories = double.tryParse(value) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter protein amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _protein = double.tryParse(value) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fat (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fat amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _fat = double.tryParse(value) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter carbs amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _carbs = double.tryParse(value) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fiber (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fiber amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _fiber = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref
                  .read(
                    dailyCaloriesProvider(
                      '${widget.userId}|${widget.mealType}',
                    ).notifier,
                  )
                  .updateCalories(
                    _foodName,
                    _calories,
                    _protein,
                    _fat,
                    _carbs,
                    _fiber,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
