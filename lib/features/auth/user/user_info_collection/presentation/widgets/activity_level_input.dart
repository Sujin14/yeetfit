import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_controller.dart';

class ActivityLevelDropdown extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const ActivityLevelDropdown({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);
    final activityLevels = [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ];

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your activity level?"),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: userInfo.activityLevel.isEmpty
                ? null
                : userInfo.activityLevel,
            decoration: const InputDecoration(
              hintText: "Select activity level",
            ),
            items: activityLevels.map((level) {
              return DropdownMenuItem(value: level, child: Text(level));
            }).toList(),
            validator: (val) =>
                val == null || val.isEmpty ? "Activity level required" : null,
            onChanged: (val) {
              if (val != null) {
                notifier.updateActivityLevel(val, context);
              }
            },
          ),
        ],
      ),
    );
  }
}
