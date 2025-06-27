import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_controller.dart';

class WeightInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const WeightInput({super.key, required this.formKey});

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends ConsumerState<WeightInput> {
  late TextEditingController _currentWeightController;
  late TextEditingController _goalWeightController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _currentWeightController = TextEditingController(
      text: userInfo.currentWeight == 0
          ? ''
          : userInfo.currentWeight.toString(),
    );
    _goalWeightController = TextEditingController(
      text: userInfo.goalWeight == 0 ? '' : userInfo.goalWeight.toString(),
    );
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _goalWeightController.dispose();
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
          const Text("What is your current weight?"),
          const SizedBox(height: 8),
          TextFormField(
            controller: _currentWeightController,
            decoration: const InputDecoration(
              hintText: "Enter current weight (kg)",
            ),
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return "Current weight required";
              }
              final weight = double.tryParse(val);
              if (weight == null || weight <= 0) return "Enter a valid weight";
              return null;
            },
            onChanged: (val) {
              final weight = double.tryParse(val) ?? 0;
              notifier.updateWeights(current: weight, context: context);
            },
          ),
          const SizedBox(height: 24),
          const Text("What is your goal weight?"),
          const SizedBox(height: 8),
          TextFormField(
            controller: _goalWeightController,
            decoration: const InputDecoration(
              hintText: "Enter goal weight (kg)",
            ),
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return "Goal weight required";
              }
              final weight = double.tryParse(val);
              if (weight == null || weight <= 0) return "Enter a valid weight";
              return null;
            },
            onChanged: (val) {
              final weight = double.tryParse(val) ?? 0;
              notifier.updateWeights(goal: weight, context: context);
            },
          ),
        ],
      ),
    );
  }
}
