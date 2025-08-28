import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/contact_us_body.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Contact Us',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const ContactUsBody(),
    );
  }
}
