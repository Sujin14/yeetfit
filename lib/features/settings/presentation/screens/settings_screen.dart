import 'package:flutter/material.dart';
import '../widgets/settings_body.dart';
import '../widgets/settings_page_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageLayout(title: 'Settings', child: SettingsBody());
  }
}
