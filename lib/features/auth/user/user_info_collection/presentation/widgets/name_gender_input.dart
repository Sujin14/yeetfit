import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_controller.dart';

class NameGenderInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const NameGenderInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);
    final gender = userInfo.gender;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your name?"),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: userInfo.name,
            decoration: const InputDecoration(hintText: "Enter your name"),
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Name required" : null,
            onChanged: (val) => notifier.updateName(val.trim(), context),
          ),
          const SizedBox(height: 24),
          const Text("Select your gender"),
          const SizedBox(height: 8),
          Row(
            children: ["Male", "Female", "Other"].map((g) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(g),
                  selected: gender == g,
                  onSelected: (_) => notifier.updateGender(g, context),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
