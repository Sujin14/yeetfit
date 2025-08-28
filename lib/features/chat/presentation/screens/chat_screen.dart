import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_screen_body.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(),
      ),
      body: const ChatScreenBody(),
    );
  }
}