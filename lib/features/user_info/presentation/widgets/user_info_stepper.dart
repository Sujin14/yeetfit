import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../providers/user_info_provider.dart';
import 'activity_level_input.dart';
import 'age_input.dart';
import 'goal_input.dart';
import 'height_input.dart';
import 'name_gender_input.dart';
import 'step_next_button.dart';
import 'step_progress_header.dart';
import 'time_duration_input.dart';
import 'weight_input.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class UserInfoStepper extends ConsumerStatefulWidget {
  final int step;

  const UserInfoStepper({super.key, required this.step});

  @override
  ConsumerState<UserInfoStepper> createState() => _UserInfoStepperState();
}

class _UserInfoStepperState extends ConsumerState<UserInfoStepper> {
  final _formKey = GlobalKey<FormState>();

  static const int _lastStep = 6;

  void _showError(String message) {
    final colors = Theme.of(context).extension<AppColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: colors.error),
    );
  }

  void _submitStep() {
    final form = _formKey.currentState;
    form?.save();
    if (form == null || !form.validate()) {
      _showError('Please fill in all required fields correctly');
      return;
    }
    final saveController = ref.read(userInfoSaveControllerProvider.notifier);
    widget.step < _lastStep
        ? saveController.saveStep(widget.step)
        : saveController.submit();
  }

  void _goToPreviousStep(UserInfoController controller) {
    final previous = controller.previousStep(widget.step);
    if (previous != null) {
      context.go(AuthRouteConstants.userInfoStepPath(previous));
    }
  }

  Widget _stepContent(int step, UserInfoController controller) {
    return switch (step) {
      0 => NameGenderInput(
        formKey: _formKey,
        onGenderChanged: controller.updateGender,
      ),
      1 => AgeInput(formKey: _formKey),
      2 => GoalInput(formKey: _formKey, onGoalChanged: controller.updateGoal),
      3 => WeightInput(formKey: _formKey),
      4 => HeightInput(formKey: _formKey),
      5 => ActivityLevelInput(
        formKey: _formKey,
        onActivityLevelChanged: controller.updateActivityLevel,
      ),
      6 => TimeDurationInput(formKey: _formKey),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserInfoSaveResult?>>(
      userInfoSaveControllerProvider,
      (_, next) {
        final result = next.value;
        if (next.hasError) {
          ref.read(userInfoSaveControllerProvider.notifier).consume();
          _showError(next.error.toString());
        } else if (result != null) {
          ref.read(userInfoSaveControllerProvider.notifier).consume();
          switch (result) {
            case UserInfoStepSaved(:final nextStep):
              context.go(AuthRouteConstants.userInfoStepPath(nextStep));
            case UserInfoSubmitted():
              context.go(ShellRouteConstants.dashboard);
          }
        }
      },
    );

    final step = widget.step;
    final controller = ref.read(userInfoControllerProvider.notifier);
    final isSaving = ref.watch(
      userInfoSaveControllerProvider.select((state) => state.isLoading),
    );

    return Column(
      children: [
        StepProgressHeader(
          step: step + 1,
          totalSteps: _lastStep + 1,
          onBack: step > 0 && !isSaving
              ? () => _goToPreviousStep(controller)
              : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _stepContent(step, controller),
          ),
        ),
        StepNextButton(
          label: step < _lastStep ? 'Next' : 'Get Started',
          isLoading: isSaving,
          onPressed: _submitStep,
        ),
      ],
    );
  }
}
