import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import 'number_picker_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';

class AgeInput extends ConsumerWidget {
  static const int _minAge = 13;
  static const int _maxAge = 100;
  static const int _defaultAge = 25;

  final GlobalKey<FormState> formKey;

  const AgeInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAge = ref.read(userInfoControllerProvider).value?.age ?? 0;
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion('How old are you?'),
          StepContentCard(
            child: NumberPickerField(
              initialValue: (savedAge == 0 ? _defaultAge : savedAge).toDouble(),
              min: _minAge.toDouble(),
              max: _maxAge.toDouble(),
              unit: 'years',
              validator: (value) =>
                  UserInfoValidators.validateAge(value?.round().toString()),
              onSaved: (value) =>
                  controller.setFormValue('age', value?.round() ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}
