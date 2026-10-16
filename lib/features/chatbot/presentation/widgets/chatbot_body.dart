import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../providers/chatbot_provider.dart';
import 'chatbot_header.dart';
import 'chatbot_message_input.dart';
import 'chatbot_message_list.dart';
import 'yana_chat_background.dart';
import 'yana_empty_chat_content.dart';

/// Empty chat: full-screen Yana image with greeting and prompts. Otherwise:
/// the message list on the screen gradient. Owns the input controller so
/// suggestion chips can pre-fill the composer.
class ChatbotBody extends ConsumerStatefulWidget {
  final String userId;

  const ChatbotBody({super.key, required this.userId});

  @override
  ConsumerState<ChatbotBody> createState() => _ChatbotBodyState();
}

class _ChatbotBodyState extends ConsumerState<ChatbotBody> {
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _prefillInput(String text) {
    _inputController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _inputFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    // Loading and error states stay with the message list.
    final isEmpty = ref.watch(
      chatbotProvider(
        widget.userId,
      ).select((messages) => messages.value?.isEmpty ?? false),
    );
    final theme = Theme.of(context);
    final lightStatusBar = isEmpty || theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightStatusBar
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isEmpty)
            const YanaChatBackground(key: ValueKey('chat-background')),
          // Keyed so the input keeps its state (and the keyboard stays up)
          // when the first message swaps the background away.
          SafeArea(
            key: const ValueKey('chat-content'),
            bottom: false,
            child: Column(
              children: [
                ChatbotHeader(overImage: isEmpty),
                Expanded(
                  child: isEmpty
                      ? YanaEmptyChatContent(
                          onSuggestionSelected: _prefillInput,
                        )
                      : ChatbotMessageList(userId: widget.userId),
                ),
                // Dark palette over the image so typed text stays light in
                // the light theme too. Always present to keep the tree stable.
                Theme(
                  data: isEmpty
                      ? theme.copyWith(extensions: const [AppColors.dark])
                      : theme,
                  child: ChatbotMessageInput(
                    userId: widget.userId,
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
