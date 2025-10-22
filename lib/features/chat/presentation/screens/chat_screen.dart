import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../widgets/chat_header.dart';
import '../widgets/date_seperator.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String adminId;

  const ChatScreen({super.key, required this.adminId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatControllerProvider(widget.adminId).notifier).setupChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider(widget.adminId));
    final chatItems = ref.watch(chatItemsProvider(chatState.messages));

    // Show snackbar for errors
    if (chatState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              chatState.error!,
              style: AppTheme.textStyles['bodyMedium']?.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(
          controller: ref.read(chatControllerProvider(widget.adminId).notifier),
        ),
      ),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Expanded(
                child: chatState.isLoadingMessages
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: false,
                              itemCount: chatItems.length,
                              itemBuilder: (context, index) {
                                final item = chatItems[index];
                                if (item is String) {
                                  return DateSeparator(dateText: item);
                                } else if (item is MessageModel) {
                                  return MessageBubble(
                                    message: item,
                                    controller: ref.read(
                                      chatControllerProvider(widget.adminId).notifier,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          if (chatState.participantTyping)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Typing...',
                                  style: AppTheme.textStyles['bodySmall']?.copyWith(
                                    color: AppTheme.colors['secondaryText'],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              MessageInput(
                controller: ref.read(
                  chatControllerProvider(widget.adminId).notifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}