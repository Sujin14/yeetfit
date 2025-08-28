import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/about_body.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'About',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const AboutBody(),
    );
  }
}