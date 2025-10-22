import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/theme/theme.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_provider.dart';

class ChatHeader extends ConsumerWidget {
  final ChatController controller;

  const ChatHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatControllerProvider(controller.adminId));

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        color: AppTheme.colors['lightBackground'],
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryAccent'], size: 30),
              onPressed: () => context.go('/user-dashboard'),
            ),
            CircleAvatar(
              radius: 25.r,
              backgroundImage: CachedNetworkImageProvider(
                chatState.participantImage.isNotEmpty
                    ? chatState.participantImage
                    : 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              chatState.participantName,
              style: AppTheme.textStyles['heading']!.copyWith(
                color: AppTheme.colors['onSurface'],
              ),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppTheme.colors['primaryAccent']),
              onSelected: (value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Chat', style: AppTheme.textStyles['titleMedium']),
                      content: Text(
                        'Are you sure you want to delete the entire chat?',
                        style: AppTheme.textStyles['bodyMedium'],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel', style: AppTheme.textStyles['bodyMedium']),
                        ),
                        TextButton(
                          onPressed: () async {
                            await controller.deleteChats();
                            Navigator.of(context).pop();
                            if (ref.read(chatControllerProvider(controller.adminId)).error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ref.read(chatControllerProvider(controller.adminId)).error!,
                                    style: AppTheme.textStyles['bodyMedium']?.copyWith(
                                      color: AppTheme.colors['onSurfaceDark'],
                                    ),
                                  ),
                                  backgroundColor: AppTheme.colors['error'],
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              context.go('/user-dashboard');
                            }
                          },
                          child: Text(
                            'Delete',
                            style: AppTheme.textStyles['bodyMedium']!.copyWith(
                              color: AppTheme.colors['error'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Chat', style: AppTheme.textStyles['bodyMedium']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}