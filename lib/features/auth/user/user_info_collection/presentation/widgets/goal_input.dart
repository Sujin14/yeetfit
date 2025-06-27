import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';

class GoalInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const GoalInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What is your goal?"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: userInfo.goal,
          decoration: const InputDecoration(
            hintText: "e.g. Lose weight, Build muscle",
          ),
          validator: (val) =>
              val == null || val.isEmpty ? "Goal required" : null,
          onChanged: notifier.updateGoal,
        ),
      ],
    );
  }
}
