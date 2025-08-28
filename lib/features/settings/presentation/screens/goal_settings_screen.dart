import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/goal_settings_body.dart';

class GoalSettingsScreen extends ConsumerWidget {
  const GoalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Goal Settings',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const GoalSettingsBody(),
    );
  }
}
