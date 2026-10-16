import 'package:flutter/material.dart';
import '../widgets/contact_us_body.dart';
import '../widgets/settings_page_layout.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsPageLayout(
      title: 'Contact Us',
      child: ContactUsBody(),
    );
  }
}
