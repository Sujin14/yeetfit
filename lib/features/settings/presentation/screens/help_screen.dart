import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/help_body.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const HelpBody(),
    );
  }
}
