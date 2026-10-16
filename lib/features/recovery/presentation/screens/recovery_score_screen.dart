import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/recovery_app_bar.dart';
import '../widgets/recovery_score_content.dart';

class RecoveryScoreScreen extends ConsumerWidget {
  const RecoveryScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(
      authStateProvider.select((user) => user.value?.uid),
    );

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const RecoveryAppBar(),
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to view your recovery score',
              )
            : RecoveryScoreContent(userId: userId),
      ),
    );
  }
}
