import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/gradient_send_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../providers/chatbot_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChatbotMessageInput extends ConsumerWidget {
  final String userId;
  final TextEditingController controller;
  final FocusNode focusNode;

  const ChatbotMessageInput({
    super.key,
    required this.userId,
    required this.controller,
    required this.focusNode,
  });

  void _sendMessage(WidgetRef ref) {
    final message = controller.text.trim();
    if (message.isNotEmpty) {
      ref.read(chatbotProvider(userId).notifier).sendMessage(message);
      controller.clear();
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        4,
        16,
        MediaQuery.paddingOf(context).bottom + 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: YeetTextField(
              controller: controller,
              focusNode: focusNode,
              hintText: 'Ask Yana anything about fitness...',
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _sendMessage(ref),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GradientSendButton(onPressed: () => _sendMessage(ref)),
        ],
      ),
    );
  }
}
