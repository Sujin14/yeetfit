import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';

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
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: userInfo.value?.activityLevel.isEmpty ?? true
                ? null
                : userInfo.value!.activityLevel,
            decoration: InputDecoration(
              hintText: "Select activity level",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
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