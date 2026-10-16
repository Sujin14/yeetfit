import 'package:flutter/material.dart';
import '../widgets/help_body.dart';
import '../widgets/settings_page_layout.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageLayout(title: 'Help & Support', child: HelpBody());
  }
}
