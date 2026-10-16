import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import 'number_picker_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';

class TimeDurationInput extends ConsumerWidget {
  static const double _minWeeks = 1;
  static const double _maxWeeks = 104;
  static const int _defaultWeeks = 12;

  final GlobalKey<FormState> formKey;

  const TimeDurationInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedWeeks =
        ref.read(userInfoControllerProvider).value?.timeDurationWeeks ??
        _defaultWeeks;
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion('How many weeks to reach your goal?'),
          StepContentCard(
            child: NumberPickerField(
              initialValue: (savedWeeks > 0 ? savedWeeks : _defaultWeeks)
                  .toDouble(),
              min: _minWeeks,
              max: _maxWeeks,
              unit: 'weeks',
              validator: (value) => UserInfoValidators.validateTimeDuration(
                value?.round().toString(),
              ),
              onSaved: (value) => controller.setFormValue(
                'timeDurationWeeks',
                value?.round() ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
