import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_button.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import '../../domain/entities/scanned_meal.dart';
import '../providers/food_log_provider.dart';
import '../providers/meal_scan_provider.dart';
import '../utils/meal_types.dart';
import 'meal_type_selector.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// "Looks right?" prompt, meal slot picker and Retake / Add to log actions.
/// [result] is the user-edited meal, so it's what gets logged.
class ScanResultLogPanel extends ConsumerStatefulWidget {
  final String userId;
  final ScannedMeal result;
  final VoidCallback onRetake;
  final ValueChanged<String> onAdded;

  const ScanResultLogPanel({
    super.key,
    required this.userId,
    required this.result,
    required this.onRetake,
    required this.onAdded,
  });

  @override
  ConsumerState<ScanResultLogPanel> createState() => _ScanResultLogPanelState();
}

class _ScanResultLogPanelState extends ConsumerState<ScanResultLogPanel> {
  late String _mealType = mealTypeForTime(DateTime.now());

  Future<void> _addToLog() async {
    final added = await ref
        .read(foodLogControllerProvider.notifier)
        .addToLog(
          userId: widget.userId,
          item: scannedMealToFoodItem(widget.result, _mealType),
        );
    if (!mounted) return;
    if (added) {
      widget.onAdded(_mealType);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't add this meal. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSaving = ref.watch(foodLogControllerProvider).isLoading;
    final canAdd = widget.result.foodName.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Looks right?',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          MealTypeSelector(
            selected: _mealType,
            onSelected: (mealType) => setState(() => _mealType = mealType),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  label: 'Retake',
                  onPressed: isSaving ? null : widget.onRetake,
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                flex: 2,
                child: GradientButton(
                  label: 'Add to log',
                  isLoading: isSaving,
                  onPressed: canAdd ? _addToLog : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
