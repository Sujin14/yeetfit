import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../utils/profile_options.dart';
import 'profile_option_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';

class GoalInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onGoalChanged;

  const GoalInput({
    super.key,
    required this.formKey,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedGoal = ref.read(userInfoControllerProvider).value?.goal ?? '';

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion("What's your fitness goal?"),
          StepContentCard(
            child: ProfileOptionField(
              options: fitnessGoalOptions,
              initialValue: savedGoal.isEmpty ? null : savedGoal,
              validator: UserInfoValidators.validateGoal,
              onChanged: onGoalChanged,
            ),
          ),
        ],
      ),
    );
  }
}
