import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';

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
    const goals = ['Weight Loss', 'Weight Gain', 'Muscle Building'];

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is your fitness goal?",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: userInfo.value?.goal.isEmpty ?? true ? null : userInfo.value!.goal,
            decoration: InputDecoration(
              hintText: "Select your goal",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              filled: true,
              fillColor: Colors.grey[100],
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