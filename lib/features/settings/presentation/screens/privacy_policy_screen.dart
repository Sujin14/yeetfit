import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/privacy_policy_body.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const PrivacyPolicyBody(),
    );
  }
}
