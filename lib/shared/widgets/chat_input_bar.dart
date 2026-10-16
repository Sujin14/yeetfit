import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'gradient_send_button.dart';
import 'yeet_text_field.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Glass composer row: text field + gradient send button.
class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Type a message...',
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.smd,
          AppSpacing.xs,
          AppSpacing.smd,
          AppSpacing.sm,
        ),
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: YeetTextField(
                  controller: controller,
                  focusNode: focusNode,
                  hintText: hintText,
                  onChanged: onChanged,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GradientSendButton(onPressed: onSend),
            ],
          ),
        ),
      ),
    );
  }
}
