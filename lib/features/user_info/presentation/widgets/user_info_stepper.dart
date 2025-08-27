// user_info_stepper.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../providers/user_info_provider.dart';
import '../widgets/activity_level_input.dart';
import '../widgets/age_input.dart';
import '../widgets/goal_input.dart';
import '../widgets/height_input.dart';
import '../widgets/name_gender_input.dart';
import '../widgets/time_duration_input.dart';
import '../widgets/weight_input.dart';
import '../../../../utils/fixed_sizes.dart';

class UserInfoStepper extends ConsumerWidget {
  final int step;

  const UserInfoStepper({super.key, required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final controller = ref.read(userInfoControllerProvider.notifier);
    final isSaving =
        ref.watch(userInfoControllerProvider.notifier.select((state) => state.isSaving));

    Widget getStepWidget(int step) {
      switch (step) {
        case 0:
          return NameGenderInput(
            formKey: formKey,
            onGenderChanged: controller.updateGender,
            onImageSelected: (image) => controller.updateProfileImage(image, context),
          );
        case 1:
          return AgeInput(formKey: formKey);
        case 2:
          return GoalInput(
            formKey: formKey,
            onGoalChanged: controller.updateGoal,
          );
        case 3:
          return WeightInput(formKey: formKey);
        case 4:
          return HeightInput(formKey: formKey);
        case 5:
          return ActivityLevelDropdown(
            formKey: formKey,
            onActivityLevelChanged: controller.updateActivityLevel,
          );
        case 6:
          return TimeDurationInput(formKey: formKey);
        default:
          return const SizedBox.shrink();
      }
    }

    return Column(
      children: [
        Text(
          'Step ${step + 1} of 7',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: FixedSizes.font18(context),
              ),
        ),
        SizedBox(height: FixedSizes.spacing(context)),
        Expanded(child: getStepWidget(step)),
        SizedBox(height: FixedSizes.spacing(context) * 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (step > 0)
              SizedBox(
                width: FixedSizes.box100(context),
                height: FixedSizes.box48(context),
                child: isSaving
                    ? ShimmerLoading(
                        width: FixedSizes.box100(context),
                        height: FixedSizes.box48(context),
                      )
                    : TextButton(
                        onPressed: () => controller.previousStep(context, step),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            fontSize: FixedSizes.font16(context),
                            color: Colors.white,
                          ),
                        ),
                      ),
              )
            else
              const SizedBox.shrink(),
            SizedBox(
              width: FixedSizes.box100(context),
              height: FixedSizes.box48(context),
              child: isSaving
                  ? ShimmerLoading(
                      width: FixedSizes.box100(context),
                      height: FixedSizes.box48(context),
                    )
                  : ElevatedButton(
                      onPressed: () => step < 6
                          ? controller.saveStepData(context, formKey, step)
                          : controller.submitUserData(context, formKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        step < 6 ? 'Next' : 'Submit',
                        style: TextStyle(
                          fontSize: FixedSizes.font16(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
