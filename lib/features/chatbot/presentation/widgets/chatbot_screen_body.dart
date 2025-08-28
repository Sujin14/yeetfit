import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/chatbot_provider.dart';
import '../widgets/chatbot_message_input.dart';
import '../widgets/chatbot_message_list.dart';

class ChatbotScreenBody extends ConsumerWidget {
  const ChatbotScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return Center(
        child: Text(
          'Please log in to use the chatbot',
          style: AppTheme.textStyles['bodyMedium']?.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      );
    }

    return Column(
      children: [
        AppBar(
          title: Text(
            'YeetFit Coach',
            style: AppTheme.textStyles['title']!.copyWith(
              color: AppTheme.colors['primaryText'],
            ),
          ),
          backgroundColor: AppTheme.colors['lightBackground'],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
            onPressed: () => ref.read(chatbotProvider(userId).notifier).navigateBack(context),
          ),
        ),
        Expanded(child: ChatbotMessageList(userId: userId)),
        ChatbotMessageInput(userId: userId),
      ],
    );
  }
}