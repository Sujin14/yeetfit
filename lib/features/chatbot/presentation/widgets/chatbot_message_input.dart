import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/chatbot_provider.dart';

class ChatbotMessageInput extends ConsumerStatefulWidget {
  final String userId;
  const ChatbotMessageInput({super.key, required this.userId});

  @override
  ConsumerState<ChatbotMessageInput> createState() =>
      _ChatbotMessageInputState();
}

class _ChatbotMessageInputState extends ConsumerState<ChatbotMessageInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      ref.read(chatbotProvider(widget.userId).notifier).sendMessage(message);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box16(context),
        vertical: FixedSizes.box12(context),
      ),
      decoration: BoxDecoration(
        color: AppTheme.colors['lightBackground'],
        border: Border(
          top: BorderSide(color: AppTheme.colors['borderGradientStart']!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
              decoration: InputDecoration(
                hintText: 'Ask about health or fitness...',
                hintStyle: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['secondaryText']!.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
                  borderSide: BorderSide(color: AppTheme.colors['borderGradientStart']!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
                  borderSide: BorderSide(color: AppTheme.colors['primaryAccent']!),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: FixedSizes.box8(context)),
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppTheme.colors['primaryAccent'],
              size: FixedSizes.icon20(context),
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
