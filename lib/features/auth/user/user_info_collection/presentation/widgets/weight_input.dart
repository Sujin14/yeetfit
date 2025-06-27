import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';

class WeightInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const WeightInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Current weight (kg)"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: userInfo.currentWeight > 0
              ? userInfo.currentWeight.toString()
              : '',
          decoration: const InputDecoration(hintText: "Enter current weight"),
          keyboardType: TextInputType.number,
          validator: (val) => double.tryParse(val ?? '') == null
              ? "Valid number required"
              : null,
          onChanged: (val) =>
              notifier.updateWeights(current: double.tryParse(val)),
        ),
        const SizedBox(height: 24),
        const Text("Goal weight (kg)"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: userInfo.goalWeight > 0
              ? userInfo.goalWeight.toString()
              : '',
          decoration: const InputDecoration(hintText: "Enter goal weight"),
          keyboardType: TextInputType.number,
          validator: (val) => double.tryParse(val ?? '') == null
              ? "Valid number required"
              : null,
          onChanged: (val) =>
              notifier.updateWeights(goal: double.tryParse(val)),
        ),
      ],
    );
  }
}
