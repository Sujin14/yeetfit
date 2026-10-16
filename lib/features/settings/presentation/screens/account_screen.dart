import 'package:flutter/material.dart';
import '../widgets/account_body.dart';
import '../widgets/settings_feedback_listener.dart';
import '../widgets/settings_page_layout.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsFeedbackListener(
      child: SettingsPageLayout(title: 'Account', child: AccountBody()),
    );
  }
}
