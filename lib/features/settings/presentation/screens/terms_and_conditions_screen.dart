import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/terms_and_conditions_body.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Terms & Conditions',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const TermsAndConditionsBody(),
    );
  }
}
