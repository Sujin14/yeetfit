import 'package:flutter/material.dart';
import 'settings_selectable_document.dart';

class TermsAndConditionsBody extends StatelessWidget {
  const TermsAndConditionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSelectableDocument(
      updated: 'Last updated: October 2024',
      intro: 'By using YeetFit, you agree to these terms.',
      sections: [
        (
          title: 'USE OF THE APP',
          body:
              'YeetFit is a personal fitness tracking tool. The app is provided for informational and personal wellness purposes only. It is not a medical device and does not provide medical advice. Always consult a qualified healthcare professional before making changes to your diet or exercise routine.',
        ),
        (
          title: 'YOUR ACCOUNT',
          body:
              'You are responsible for maintaining the confidentiality of your account credentials. You must provide accurate information when creating your account.',
        ),
        (
          title: 'HEALTH DATA',
          body:
              "The health data you enter is used solely to provide the app's features. You are responsible for the accuracy of the data you enter.",
        ),
        (
          title: 'ACCEPTABLE USE',
          body:
              'You agree not to misuse the app, attempt to access other users\' data, reverse engineer the app, or use the app for any unlawful purpose.',
        ),
        (
          title: 'INTELLECTUAL PROPERTY',
          body:
              'All content, design, and code within YeetFit is the property of YeetFit and may not be reproduced without permission.',
        ),
        (
          title: 'LIMITATION OF LIABILITY',
          body:
              'YeetFit is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the app or reliance on its data.',
        ),
        (
          title: 'TERMINATION',
          body:
              'We reserve the right to terminate accounts that violate these terms.',
        ),
        (
          title: 'CHANGES TO TERMS',
          body:
              'We may update these terms at any time. Continued use of the app constitutes acceptance of the updated terms.',
        ),
        (
          title: 'CONTACT',
          body:
              'For any questions about these terms, email sujinksureshofcl@gmail.com.',
        ),
      ],
    );
  }
}
