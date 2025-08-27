// goal_input.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../../../../utils/fixed_sizes.dart';

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
    final userInfo = ref.watch(userInfoControllerProvider);
    const goals = ['weight loss', 'weight gain', 'muscle building'];

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is your fitness goal?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          DropdownButtonFormField<String>(
            value: userInfo.value?.goal.isEmpty ?? true
                ? null
                : userInfo.value!.goal,
            decoration: InputDecoration(
              hintText: "Select your goal",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppTheme.colors['gray']!,
            ),
            items: goals.map((goal) {
              return DropdownMenuItem<String>(value: goal, child: Text(goal));
            }).toList(),
            validator: UserInfoValidators.validateGoal,
            onChanged: (value) {
              if (value != null) {
                onGoalChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
