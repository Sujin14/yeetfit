import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../domain/entities/scanned_meal.dart';
import 'editable_macro_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Editable AI estimate. Starts from [initialResult] and reports every edit
/// through [onChanged].
class ScanResultCard extends StatefulWidget {
  final ScannedMeal initialResult;
  final ValueChanged<ScannedMeal> onChanged;

  const ScanResultCard({
    super.key,
    required this.initialResult,
    required this.onChanged,
  });

  @override
  State<ScanResultCard> createState() => _ScanResultCardState();
}

class _ScanResultCardState extends State<ScanResultCard> {
  late ScannedMeal _meal = widget.initialResult;
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialResult.foodName,
  );
  late final TextEditingController _servingController = TextEditingController(
    text: widget.initialResult.servingSize,
  );

  void _update(ScannedMeal meal) {
    _meal = meal;
    widget.onChanged(meal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _servingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.textSecondary);
    final initial = widget.initialResult;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Food name', style: labelStyle),
            const SizedBox(height: 6),
            YeetTextField(
              controller: _nameController,
              hintText: 'What did you eat?',
              prefixIcon: Icons.restaurant_outlined,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _update(_meal.copyWith(foodName: value)),
            ),
            const SizedBox(height: AppSpacing.smd),
            Text('Serving size', style: labelStyle),
            const SizedBox(height: 6),
            YeetTextField(
              controller: _servingController,
              hintText: 'e.g. 1 bowl (250 g)',
              prefixIcon: Icons.scale_outlined,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _update(_meal.copyWith(servingSize: value)),
            ),
            Divider(height: 32, color: Colors.white.withValues(alpha: 0.15)),
            EditableMacroRow(
              label: 'Calories',
              unit: 'kcal',
              initialValue: initial.calories.roundToDouble(),
              accentColor: colors.calories,
              onChanged: (value) => _update(_meal.copyWith(calories: value)),
            ),
            EditableMacroRow(
              label: 'Protein',
              unit: 'g',
              initialValue: initial.protein,
              accentColor: colors.protein,
              onChanged: (value) => _update(_meal.copyWith(protein: value)),
            ),
            EditableMacroRow(
              label: 'Carbs',
              unit: 'g',
              initialValue: initial.carbs,
              accentColor: colors.carbs,
              onChanged: (value) => _update(_meal.copyWith(carbs: value)),
            ),
            EditableMacroRow(
              label: 'Fat',
              unit: 'g',
              initialValue: initial.fat,
              accentColor: colors.fat,
              onChanged: (value) => _update(_meal.copyWith(fat: value)),
            ),
          ],
        ),
      ),
    );
  }
}
