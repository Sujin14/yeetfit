import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/user_info_controller.dart';
import '../widgets/activity_level_input.dart';
import '../widgets/age_input.dart';
import '../widgets/goal_input.dart';
import '../widgets/height_input.dart';
import '../widgets/name_gender_input.dart';
import '../widgets/weight_input.dart';

class UserInfoStepPage extends ConsumerWidget {
  final int step;

  UserInfoStepPage({super.key, required this.step});

  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(userInfoControllerProvider.notifier);

    Widget getStepWidget(int step) {
      switch (step) {
        case 0:
          return NameGenderInput(formKey: formKeys[0]);
        case 1:
          return AgeInput(formKey: formKeys[1]);
        case 2:
          return GoalInput(formKey: formKeys[2]);
        case 3:
          return WeightInput(formKey: formKeys[3]);
        case 4:
          return HeightInput(formKey: formKeys[4]);
        case 5:
          return ActivityLevelDropdown(formKey: formKeys[5]);
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: getStepWidget(step)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (step > 0)
                  ElevatedButton(
                    onPressed: () => context.go('/user-info-step/${step - 1}'),
                    child: const Text("Back"),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKeys[step].currentState!.validate()) {
                      if (step < 5) {
                        context.go('/user-info-step/${step + 1}');
                      } else {
                        await notifier.saveUserData(context);
                      }
                    }
                  },
                  child: Text(step < 5 ? "Next" : "Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
