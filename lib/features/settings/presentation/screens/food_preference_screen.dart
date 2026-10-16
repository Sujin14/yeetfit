import 'package:flutter/material.dart';
import '../widgets/food_preferences_form.dart';
import '../widgets/settings_feedback_listener.dart';
import '../widgets/settings_page_layout.dart';
import '../widgets/settings_profile_body.dart';

class FoodPreferencesScreen extends StatelessWidget {
  const FoodPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsFeedbackListener(
      child: SettingsPageLayout(
        title: 'Food Preferences',
        child: SettingsProfileBody(
          builder: (userInfo) => FoodPreferencesForm(userInfo: userInfo),
        ),
      ),
    );
  }
}
