import 'package:hooks_riverpod/hooks_riverpod.dart';

final userInfoStepProvider = StateNotifierProvider<UserInfoStepController, int>(
  (ref) => UserInfoStepController(),
);

class UserInfoStepController extends StateNotifier<int> {
  UserInfoStepController() : super(0);

  void updateStep(int newStep) {
    state = newStep;
  }

  void nextStep() {
    if (state < 5) state++;
  }

  void previousStep() {
    if (state > 0) state--;
  }
}
