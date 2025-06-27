import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_controller.dart';

class AgeInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const AgeInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your age?"),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: userInfo.age == 0 ? '' : userInfo.age.toString(),
            decoration: const InputDecoration(hintText: "Enter your age"),
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Age required";
              final age = int.tryParse(val);
              if (age == null || age < 1 || age > 150)
                return "Enter a valid age";
              return null;
            },
            onChanged: (val) {
              final age = int.tryParse(val) ?? 0;
              notifier.updateAge(age, context);
            },
          ),
        ],
      ),
    );
  }
}
