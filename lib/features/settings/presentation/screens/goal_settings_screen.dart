import 'package:flutter/material.dart';
import '../widgets/goal_settings_form.dart';
import '../widgets/settings_feedback_listener.dart';
import '../widgets/settings_page_layout.dart';
import '../widgets/settings_profile_body.dart';

class GoalSettingsScreen extends StatelessWidget {
  const GoalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsFeedbackListener(
      child: SettingsPageLayout(
        title: 'Goal Settings',
        child: SettingsProfileBody(
          builder: (userInfo) => GoalSettingsForm(userInfo: userInfo),
        ),
      ),
    );
  }
}
