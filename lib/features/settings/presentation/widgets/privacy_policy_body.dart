import 'package:flutter/material.dart';
import 'settings_selectable_document.dart';

class PrivacyPolicyBody extends StatelessWidget {
  const PrivacyPolicyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSelectableDocument(
      updated: 'Last updated: October 2024',
      intro:
          'YeetFit ("we", "our", or "us") is committed to protecting your privacy. This policy explains what information we collect, how we use it, and your rights.',
      sections: [
        (
          title: 'INFORMATION WE COLLECT',
          body:
              '- Health and fitness data you enter: steps, water intake, sleep hours, calorie intake, body weight, and meal logs\n'
              '- Account information: name, email address, date of birth, height, and weight\n'
              '- Usage data: app interactions collected anonymously via Firebase Analytics',
        ),
        (
          title: 'HOW WE USE YOUR INFORMATION',
          body:
              '- To provide and personalise your fitness tracking experience\n'
              '- To calculate progress toward your goals\n'
              '- To improve the app through anonymous usage analytics',
        ),
        (
          title: 'DATA STORAGE',
          body:
              'Your data is stored securely using Google Firebase (Firestore and Authentication). Firebase is GDPR-compliant. We do not sell, trade, or rent your personal information to third parties.',
        ),
        (
          title: 'DATA RETENTION',
          body:
              'Your data is retained as long as your account is active. You can delete your account and all associated data at any time from Settings → Account → Delete Account.',
        ),
        (
          title: 'YOUR RIGHTS',
          body:
              'You have the right to access, correct, or delete your personal data at any time. To exercise these rights, contact us at sujinksureshofcl@gmail.com.',
        ),
        (
          title: "CHILDREN'S PRIVACY",
          body:
              'YeetFit is not intended for users under the age of 13. We do not knowingly collect data from children.',
        ),
        (
          title: 'CHANGES TO THIS POLICY',
          body:
              'We may update this policy from time to time. Continued use of the app after changes constitutes acceptance of the updated policy.',
        ),
        (
          title: 'CONTACT',
          body:
              'For any privacy-related questions, email us at sujinksureshofcl@gmail.com.',
        ),
      ],
    );
  }
}
