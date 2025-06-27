import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';

class AgeInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const AgeInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What is your age?"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: userInfo.age > 0 ? userInfo.age.toString() : '',
          decoration: const InputDecoration(hintText: "Enter your age"),
          keyboardType: TextInputType.number,
          validator: (val) {
            final age = int.tryParse(val ?? '');
            return (age == null || age <= 0) ? "Valid age required" : null;
          },
          onChanged: (val) => notifier.updateAge(int.tryParse(val) ?? 0),
        ),
      ],
    );
  }
}
