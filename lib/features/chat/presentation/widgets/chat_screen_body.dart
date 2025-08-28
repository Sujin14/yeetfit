import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import 'date_seperator.dart';

class ChatScreenBody extends ConsumerWidget {
  const ChatScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatControllerProvider(ref.read(chatControllerProvider as ProviderListenable).adminId));
    final chatItems = ref.watch(chatItemsProvider(chatState.messages));

    return SafeArea(
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
                                return MessageBubble(message: item);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        if (chatState.participantTyping)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 16.w,
                            ),
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
            MessageInput(),
          ],
        ),
      ),
    );
  }
}