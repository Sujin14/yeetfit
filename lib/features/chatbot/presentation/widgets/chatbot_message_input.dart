import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['primaryAccent']!,
                  ),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppTheme.colors['primaryAccent'],
              size: 24.sp,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
