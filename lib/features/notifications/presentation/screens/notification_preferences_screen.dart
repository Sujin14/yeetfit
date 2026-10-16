import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/settings/presentation/widgets/settings_app_bar.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/notification_preferences_body.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(
      authStateProvider.select((user) => user.value?.uid),
    );

    return Scaffold(
      appBar: const SettingsAppBar(title: 'Notifications'),
      body: userId == null
          ? const SignInRequiredView(
              message: 'Sign in to manage notification settings.',
            )
          : NotificationPreferencesBody(userId: userId),
    );
  }
}
