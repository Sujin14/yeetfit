import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../providers/user_info_controller.dart';
import '../widgets/activity_level_input.dart';
import '../widgets/age_input.dart';
import '../widgets/goal_input.dart';
import '../widgets/height_input.dart';
import '../widgets/name_gender_input.dart';
import '../widgets/time_duration_input.dart';
import '../widgets/weight_input.dart';

class UserInfoStepper extends ConsumerWidget {
  final int step;

  const UserInfoStepper({super.key, required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final controller = ref.read(userInfoControllerProvider.notifier);
    final isSaving = ref.watch(userInfoControllerProvider.notifier.select((state) => state.isSaving));

    Widget getStepWidget(int step) {
      switch (step) {
        case 0:
          return NameGenderInput(
            formKey: formKey,
            onNameChanged: controller.updateName,
            onGenderChanged: controller.updateGender,
            onImageSelected: (image) => controller.updateProfileImage(image, context),
          );
        case 1:
          return AgeInput(
            formKey: formKey,
            onAgeChanged: controller.updateAge,
          );
        case 2:
          return GoalInput(
            formKey: formKey,
            onGoalChanged: controller.updateGoal,
          );
        case 3:
          return WeightInput(
            formKey: formKey,
            onWeightChanged: controller.updateWeights,
          );
        case 4:
          return HeightInput(
            formKey: formKey,
            onHeightChanged: controller.updateHeight,
          );
        case 5:
          return ActivityLevelDropdown(
            formKey: formKey,
            onActivityLevelChanged: controller.updateActivityLevel,
          );
        case 6:
          return TimeDurationInput(
            formKey: formKey,
            onDurationChanged: controller.updateTimeDuration,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return Column(
      children: [
        Text(
          'Step ${step + 1} of 7',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        SizedBox(height: 16.h),
        Expanded(child: getStepWidget(step)),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (step > 0)
              SizedBox(
                width: 100.w,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: isSaving ? null : () => controller.previousStep(context, step),
                  child: const Text('Previous'),
                ),
              )
            else
              const SizedBox.shrink(),
            SizedBox(
              width: 100.w,
              height: 48.h,
              child: isSaving
                  ? ShimmerLoading(width: 100.w, height: 48.h)
                  : ElevatedButton(
                      onPressed: () => step < 6
                          ? controller.saveStepData(context, formKey, step)
                          : controller.submitUserData(context, formKey),
                      child: Text(step < 6 ? 'Next' : 'Submit'),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}