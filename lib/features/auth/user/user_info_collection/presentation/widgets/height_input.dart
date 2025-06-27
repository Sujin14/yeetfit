import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';

class HeightInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const HeightInput({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What is your height (cm)?"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: userInfo.height > 0 ? userInfo.height.toString() : '',
          decoration: const InputDecoration(hintText: "Enter your height"),
          keyboardType: TextInputType.number,
          validator: (val) => double.tryParse(val ?? '') == null
              ? "Valid number required"
              : null,
          onChanged: (val) => notifier.updateHeight(double.tryParse(val) ?? 0),
        ),
      ],
    );
  }
}
