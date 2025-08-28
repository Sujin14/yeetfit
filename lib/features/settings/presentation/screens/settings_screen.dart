import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../widgets/settings_body.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: const SettingsBody(),
    );
  }
}
