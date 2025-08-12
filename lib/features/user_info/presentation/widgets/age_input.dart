import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_controller.dart';
import '../../domain/validators/user_info_validators.dart';

class AgeInput extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(int) onAgeChanged;

  const AgeInput({
    super.key,
    required this.formKey,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your age?"),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: userInfo.value?.age == 0 ? '' : userInfo.value!.age.toString(),
            decoration: const InputDecoration(hintText: "Enter your age"),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateAge,
            onChanged: (val) {
              final age = int.tryParse(val) ?? 0;
              onAgeChanged(age);
            },
          ),
        ],
      ),
    );
  }
}