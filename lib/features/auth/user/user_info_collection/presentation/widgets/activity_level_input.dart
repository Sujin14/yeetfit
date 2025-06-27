import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';

class ActivityLevelDropdown extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const ActivityLevelDropdown({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("How active are you?"),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: userInfo.activityLevel.isNotEmpty
              ? userInfo.activityLevel
              : null,
          items: const [
            DropdownMenuItem(value: "Sedentary", child: Text("Sedentary")),
            DropdownMenuItem(value: "Light", child: Text("Light")),
            DropdownMenuItem(value: "Moderate", child: Text("Moderate")),
            DropdownMenuItem(value: "Vigorous", child: Text("Vigorous")),
          ],
          onChanged: (val) {
            if (val != null) {
              notifier.updateActivityLevel(val);
            }
          },
          validator: (val) =>
              val == null || val.isEmpty ? "Select activity level" : null,
          decoration: const InputDecoration(hintText: "Select activity level"),
        ),
      ],
    );
  }
}
