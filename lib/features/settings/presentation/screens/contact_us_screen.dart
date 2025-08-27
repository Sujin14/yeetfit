import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../widgets/contact_us_body.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: ContactUsBody(),
    );
  }
}