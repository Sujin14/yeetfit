import 'package:flutter/material.dart';
import 'faq_item.dart';
import 'settings_document_card.dart';
import 'settings_section_label.dart';

class HelpBody extends StatelessWidget {
  const HelpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsDocumentCard(
          intro:
              'Need assistance? Here are some common questions and answers to help you get started.',
          sections: [],
        ),
        SettingsSectionLabel('FAQs'),
        FaqItem(
          question: 'How do I update my profile?',
          answer:
              'Go to Settings > Basic Information to update your profile details.',
        ),
        FaqItem(
          question: 'How do I set my fitness goals?',
          answer:
              'Navigate to Settings > Goal Settings to set your fitness goal and target weight.',
        ),
        FaqItem(
          question: 'How do I contact support?',
          answer: 'Email us at support@yeetfit.com for assistance.',
        ),
      ],
    );
  }
}
