import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import 'number_picker_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';

class HeightInput extends ConsumerWidget {
  static const double _minHeight = 100;
  static const double _maxHeight = 250;
  static const double _defaultHeight = 170;

  final GlobalKey<FormState> formKey;

  const HeightInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedHeight = ref.read(userInfoControllerProvider).value?.height ?? 0;
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion('How tall are you?'),
          StepContentCard(
            child: NumberPickerField(
              initialValue: savedHeight > 0
                  ? savedHeight.roundToDouble()
                  : _defaultHeight,
              min: _minHeight,
              max: _maxHeight,
              unit: 'cm',
              validator: (value) =>
                  UserInfoValidators.validateHeight(value?.toString()),
              onSaved: (value) => controller.setFormValue('height', value ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}
