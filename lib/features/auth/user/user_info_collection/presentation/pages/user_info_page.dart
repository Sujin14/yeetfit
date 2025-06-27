import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/user_info_notifier.dart';
import '../../application/user_info_step_controller.dart';
import '../widgets/activity_level_input.dart';
import '../widgets/age_input.dart';
import '../widgets/goal_input.dart';
import '../widgets/height_input.dart';
import '../widgets/name_gender_input.dart';
import '../widgets/weight_input.dart';

class UserInfoStepPage extends ConsumerStatefulWidget {
  final int step;

  const UserInfoStepPage({super.key, required this.step});

  @override
  ConsumerState<UserInfoStepPage> createState() => _UserInfoStepPageState();
}

class _UserInfoStepPageState extends ConsumerState<UserInfoStepPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(userInfoControllerProvider);
    final progress = (widget.step + 1) / 6;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentStep != widget.step) {
        ref.read(userInfoStepProvider.notifier).updateStep(widget.step);
      }
    });

    Widget currentStepWidget;
    switch (widget.step) {
      case 0:
        currentStepWidget = NameGenderInput(formKey: _formKey);
        break;
      case 1:
        currentStepWidget = AgeInput(formKey: _formKey);
        break;
      case 2:
        currentStepWidget = GoalInput(formKey: _formKey);
        break;
      case 3:
        currentStepWidget = WeightInput(formKey: _formKey);
        break;
      case 4:
        currentStepWidget = HeightInput(formKey: _formKey);
        break;
      case 5:
        currentStepWidget = ActivityLevelDropdown(formKey: _formKey);
        break;
      default:
        currentStepWidget = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("User Info"), centerTitle: true),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(key: _formKey, child: currentStepWidget),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.step > 0)
                  ElevatedButton(
                    onPressed: () {
                      context.go('/user-info-step/${widget.step - 1}');
                    },
                    child: const Text("Previous"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.step < 5) {
                        context.go('/user-info-step/${widget.step + 1}');
                      } else {
                        ref
                            .read(userInfoControllerProvider.notifier)
                            .saveUserData(context);
                      }
                    }
                  },
                  child: Text(widget.step < 5 ? "Next" : "Finish"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
