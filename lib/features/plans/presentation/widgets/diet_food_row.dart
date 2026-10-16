import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class DietFoodRow extends StatelessWidget {
  final Map<String, dynamic> food;

  const DietFoodRow({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final macros = Map<String, dynamic>.from(
      food['macronutrients'] as Map? ?? const {},
    );
    final description = food['description']?.toString();
    String macro(String key) =>
        (macros[key] as num?)?.toStringAsFixed(1) ?? '0.0';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${food['name'] ?? 'Unknown'}',
                  style: textTheme.bodyLarge!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
              ),
              Text(
                '${food['calories'] ?? 'N/A'} kcal',
                style: textTheme.bodySmall!.copyWith(color: colors.calories),
              ),
            ],
          ),
          Text(
            '${food['quantity'] ?? 'N/A'} ${food['unit'] ?? 'g'} · '
            'P ${macro('protein')}g · C ${macro('carbs')}g · '
            'F ${macro('fats')}g',
            style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
          ),
          if (description != null && description.isNotEmpty)
            Text(
              description,
              style: textTheme.bodySmall!.copyWith(color: colors.textMuted),
            ),
        ],
      ),
    );
  }
}
