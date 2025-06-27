import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_controller.dart';

class GoalInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const GoalInput({super.key, required this.formKey});

  @override
  ConsumerState<GoalInput> createState() => _GoalInputState();
}

class _GoalInputState extends ConsumerState<GoalInput> {
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _goalController = TextEditingController(text: userInfo.goal);
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your fitness goal?"),
          const SizedBox(height: 8),
          TextFormField(
            controller: _goalController,
            decoration: const InputDecoration(hintText: "Enter your goal"),
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Goal required" : null,
            onChanged: (val) => notifier.updateGoal(val.trim(), context),
          ),
        ],
      ),
    );
  }
}
