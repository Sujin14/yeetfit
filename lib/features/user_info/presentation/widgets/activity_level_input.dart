import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_controller.dart';
import '../../domain/validators/user_info_validators.dart';

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
              border: OutlineInputBorder(),
            ),
            items: activityLevels.map((level) {
              return DropdownMenuItem<String>(value: level, child: Text(level));
            }).toList(),
            validator: UserInfoValidators.validateActivityLevel,
            onChanged: (value) {
              if (value != null) {
                notifier.updateActivityLevel(value, context);
              }
            },
          ),
        ],
      ),
    );
  }
}
