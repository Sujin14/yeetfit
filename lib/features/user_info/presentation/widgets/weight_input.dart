import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import 'number_picker_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WeightInput extends ConsumerWidget {
  static const double _minWeight = 30;
  static const double _maxWeight = 300;
  static const double _defaultWeight = 70;

  final GlobalKey<FormState> formKey;

  const WeightInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.read(userInfoControllerProvider).value;
    final controller = ref.read(userInfoControllerProvider.notifier);
    final current = (userInfo?.currentWeight ?? 0) > 0
        ? userInfo!.currentWeight
        : _defaultWeight;
    final goal = (userInfo?.goalWeight ?? 0) > 0
        ? userInfo!.goalWeight
        : current;

    String? validate(double? value) =>
        UserInfoValidators.validateWeight(value?.toString());

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion("What's your current weight?"),
          StepContentCard(
            child: NumberPickerField(
              initialValue: current,
              min: _minWeight,
              max: _maxWeight,
              step: 0.5,
              fractionDigits: 1,
              unit: 'kg',
              validator: validate,
              onSaved: (value) =>
                  controller.setFormValue('currentWeight', value ?? 0),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const StepQuestion("What's your goal weight?"),
          StepContentCard(
            child: NumberPickerField(
              initialValue: goal,
              min: _minWeight,
              max: _maxWeight,
              step: 0.5,
              fractionDigits: 1,
              unit: 'kg',
              validator: validate,
              onSaved: (value) =>
                  controller.setFormValue('goalWeight', value ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}
