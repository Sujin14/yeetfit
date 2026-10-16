import 'package:flutter/material.dart';
import '../widgets/privacy_policy_body.dart';
import '../widgets/settings_page_layout.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageLayout(
      title: 'Privacy Policy',
      child: PrivacyPolicyBody(),
    );
  }
}
