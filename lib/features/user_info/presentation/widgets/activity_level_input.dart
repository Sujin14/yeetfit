// activity_level_dropdown.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../../../../utils/fixed_sizes.dart';

class ActivityLevelDropdown extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onActivityLevelChanged;

  const ActivityLevelDropdown({
    super.key,
    required this.formKey,
    required this.onActivityLevelChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoControllerProvider);
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
          Text(
            "What is your activity level?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          DropdownButtonFormField<String>(
            value: userInfo.value?.activityLevel.isEmpty ?? true
                ? null
                : userInfo.value!.activityLevel,
            decoration: InputDecoration(
              hintText: "Select activity level",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            items: activityLevels.map((level) {
              return DropdownMenuItem<String>(value: level, child: Text(level));
            }).toList(),
            validator: UserInfoValidators.validateActivityLevel,
            onChanged: (value) {
              if (value != null) {
                onActivityLevelChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
