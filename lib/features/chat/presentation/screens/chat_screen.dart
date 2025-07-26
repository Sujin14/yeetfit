import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../widgets/chat_header.dart';
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
      ref.read(chatControllerProvider(widget.adminId).notifier).setupChat(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider(widget.adminId));

    return Scaffold(
      backgroundColor: AppTheme.colors['darkBackground'],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(
          controller: ref.read(chatControllerProvider(widget.adminId).notifier),
        ),
      ),
      body: chatState.isLoadingMessages
          ? const Center(child: CircularProgressIndicator())
          : GlassmorphicContainer(
              color: AppTheme.colors['primaryAccent']!,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chatState.messages.length,
                      itemBuilder: (context, index) {
                        final msg = chatState.messages[index];
                        return MessageBubble(
                          message: msg,
                          controller: ref.read(chatControllerProvider(widget.adminId).notifier),
                        );
                      },
                    ),
                  ),
                  MessageInput(controller: ref.read(chatControllerProvider(widget.adminId).notifier)),
                ],
              ),
            ),
    );
  }
}
