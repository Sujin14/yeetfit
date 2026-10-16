import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/chatbot_body.dart';

class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to chat with Yana',
              )
            : ChatbotBody(userId: userId),
      ),
    );
  }
}
