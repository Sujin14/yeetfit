import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/payment_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';


class ChatScreen extends ConsumerWidget {
  final String adminId;

  const ChatScreen({super.key, required this.adminId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatControllerProvider(adminId));

    ref.read(chatControllerProvider(adminId).notifier).setupChat(context);

    return Scaffold(
      backgroundColor: AppTheme.colors['darkBackground'],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(controller: ref.read(chatControllerProvider(adminId).notifier)),
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
                          controller: ref.read(chatControllerProvider(adminId).notifier),
                        );
                      },
                    ),
                  ),
                  MessageInput(controller: ref.read(chatControllerProvider(adminId).notifier)),
                ],
              ),
            ),
    );
  }
}