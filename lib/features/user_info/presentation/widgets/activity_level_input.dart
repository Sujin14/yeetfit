import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../utils/profile_options.dart';
import 'profile_option_field.dart';
import 'step_content_card.dart';
import 'step_question.dart';

class ActivityLevelInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onActivityLevelChanged;

  const ActivityLevelInput({
    super.key,
    required this.formKey,
    required this.onActivityLevelChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved =
        ref.read(userInfoControllerProvider).value?.activityLevel ?? '';

    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepQuestion('How active are you?'),
          StepContentCard(
            child: ProfileOptionField(
              options: activityLevelOptions,
              initialValue: saved.isEmpty ? null : saved,
              validator: UserInfoValidators.validateActivityLevel,
              onChanged: onActivityLevelChanged,
            ),
          ),
        ],
      ),
    );
  }
}
