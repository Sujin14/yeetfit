import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/theme.dart';
import '../widgets/chatbot_message_input.dart';
import '../widgets/chatbot_message_list.dart';


class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.colors['lightBackground'],
        body: const Center(child: Text('Please log in to use the chatbot')),
      );
    }

    return Scaffold(
      appBar: AppBar(
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
          onPressed: () => context.pushReplacement('/user-dashboard'),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: ChatbotMessageList(userId: userId)),
          ChatbotMessageInput(userId: userId),
        ],
      ),
    );
  }
}