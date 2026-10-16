import 'package:flutter/material.dart';
import '../widgets/settings_page_layout.dart';
import '../widgets/terms_and_conditions_body.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageLayout(
      title: 'Terms & Conditions',
      child: TermsAndConditionsBody(),
    );
  }
}
