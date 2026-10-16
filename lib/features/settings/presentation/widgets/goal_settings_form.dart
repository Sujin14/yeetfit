import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/number_picker.dart';
import 'package:yeetfit/shared/widgets/selectable_option_tile.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/presentation/utils/profile_options.dart';
import '../providers/settings_provider.dart';
import 'settings_field_label.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class GoalSettingsForm extends ConsumerStatefulWidget {
  final UserInfoModel userInfo;

  const GoalSettingsForm({super.key, required this.userInfo});

  @override
  ConsumerState<GoalSettingsForm> createState() => _GoalSettingsFormState();
}

class _GoalSettingsFormState extends ConsumerState<GoalSettingsForm> {
  static const double _minWeight = 30;
  static const double _maxWeight = 300;
  static const double _defaultWeight = 70;

  late String _goal;
  late double _goalWeight;

  @override
  void initState() {
    super.initState();
    final userInfo = widget.userInfo;
    final validGoals = fitnessGoalOptions.map((option) => option.value);
    _goal = validGoals.contains(userInfo.goal)
        ? userInfo.goal
        : fitnessGoalOptions.first.value;
    final start = userInfo.goalWeight > 0
        ? userInfo.goalWeight
        : (userInfo.currentWeight > 0
              ? userInfo.currentWeight
              : _defaultWeight);
    _goalWeight = double.parse(
      start.clamp(_minWeight, _maxWeight).toStringAsFixed(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SettingsFieldLabel('Fitness goal'),
                for (final option in fitnessGoalOptions) ...[
                  SelectableOptionTile(
                    icon: option.icon,
                    label: option.label,
                    isSelected: _goal == option.value,
                    onTap: () => setState(() => _goal = option.value),
                  ),
                  if (option != fitnessGoalOptions.last)
                    const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: NumberPicker(
              label: 'Target weight',
              value: _goalWeight,
              min: _minWeight,
              max: _maxWeight,
              step: 0.5,
              fractionDigits: 1,
              unit: 'kg',
              onChanged: (value) => setState(() => _goalWeight = value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(
            label: 'Save',
            isLoading: isSaving,
            onPressed: () => ref
                .read(settingsControllerProvider.notifier)
                .updateGoals(goal: _goal, goalWeight: _goalWeight),
          ),
        ],
      ),
    );
  }
}
