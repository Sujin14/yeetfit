import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/progress_screen_body.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Progress'),
      body: const ProgressScreenBody(),
    );
  }
}
