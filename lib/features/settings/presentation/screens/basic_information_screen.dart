import 'package:flutter/material.dart';
import '../widgets/basic_information_form.dart';
import '../widgets/settings_feedback_listener.dart';
import '../widgets/settings_page_layout.dart';
import '../widgets/settings_profile_body.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsFeedbackListener(
      child: SettingsPageLayout(
        title: 'Basic Information',
        child: SettingsProfileBody(
          builder: (userInfo) => BasicInformationForm(userInfo: userInfo),
        ),
      ),
    );
  }
}
